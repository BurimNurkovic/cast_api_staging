module AmazonClient
  def self.authorize(token:)
    uri = amazon_uri(token)
    HTTParty.get(uri)
  end

  def self.search(hair_item_page, skin_item_page, hair_keyword, skin_keyword, hair_type, skin_type)
    timestamp = CGI.escape(Time.now.utc.iso8601)

    # get hair products
    signed = get_signature(hair_item_page, URI.encode(hair_keyword.join(" ") + " hair " + hair_type), timestamp)
    # puts "singed = #{signed}"
    xml_content = HTTP.get(signed)
    data = Hash.from_xml(xml_content)
    if data["ItemSearchErrorResponse"]
      hair = {error: data["ItemSearchErrorResponse"]["Error"]["Message"]}
    else
      hair = generate_product_object(data["ItemSearchResponse"]["Items"], hair_item_page, 0)
      if hair[:error] and hair[:error][0] == "True" and hair_keyword.length
        signed = get_signature(hair_item_page, URI.encode(hair_keyword[0] + " hair " + hair_type), timestamp)
        # puts "singed = #{signed}"
        xml_content = HTTP.get(signed)
        data = Hash.from_xml(xml_content)
        if data["ItemSearchErrorResponse"]
          hair = {error: data["ItemSearchErrorResponse"]["Error"]["Message"]}
        else
          hair = generate_product_object(data["ItemSearchResponse"]["Items"], hair_item_page, 0)
          if hair[:error]
            signed = get_signature(hair_item_page, URI.encode("hair " + hair_type), timestamp)
            # puts "singed = #{signed}"
            xml_content = HTTP.get(signed)
            data = Hash.from_xml(xml_content)
            if data["ItemSearchErrorResponse"]
              hair = {error: data["ItemSearchErrorResponse"]["Error"]["Message"]}
            else
              hair = generate_product_object(data["ItemSearchResponse"]["Items"], hair_item_page, 0)
            end
          end
        end
      end
    end

    # get skin products
    signed = get_signature(skin_item_page, URI.encode(skin_keyword.join(" ") + " skin " + skin_type), timestamp)
    # puts "singed = #{signed}"
    xml_content = HTTP.get(signed)
    data = Hash.from_xml(xml_content)
    if data["ItemSearchErrorResponse"]
      skin = {error: data["ItemSearchErrorResponse"]["Error"]["Message"]}
    else
      skin = generate_product_object(data["ItemSearchResponse"]["Items"], skin_item_page, 1)
      if skin[:error] and skin[:error][0] == "True" and skin_keyword.length
        signed = get_signature(skin_item_page, URI.encode(skin_keyword[0] + " skin " + skin_type), timestamp)
        # puts "singed = #{signed}"
        xml_content = HTTP.get(signed)
        data = Hash.from_xml(xml_content)
        if data["ItemSearchErrorResponse"]
          skin = {error: data["ItemSearchErrorResponse"]["Error"]["Message"]}
        else
          skin = generate_product_object(data["ItemSearchResponse"]["Items"], skin_item_page, 1)
          if skin[:error]
            signed = get_signature(skin_item_page, URI.encode("skin " + skin_type), timestamp)
            # puts "singed = #{signed}"
            xml_content = HTTP.get(signed)
            data = Hash.from_xml(xml_content)
            if data["ItemSearchErrorResponse"]
              skin = {error: data["ItemSearchErrorResponse"]["Error"]["Message"]}
            else
              skin = generate_product_object(data["ItemSearchResponse"]["Items"], skin_item_page, 1)
            end
          end
        end
      end
    end

    response = {
      :hair => hair,
      :skin => skin
    }
  end

  private

  def self.amazon_uri(token)
    URI.parse(URI.encode("https://api.amazon.com/auth/O2/tokeninfo?access_token=#{token}".strip))
  end

  def self.get_signature(item_page, keyword, timestamp)
    query = "AWSAccessKeyId=#{ENV['AWS_ACCESS_KEY_ID'].strip}&AssociateTag=#{ENV['AWS_ASSOCIATE_TAG'].strip}&ItemPage=#{item_page}&Keywords=#{keyword}&Operation=ItemSearch&ResponseGroup=Small%2C%20Images%2C%20OfferSummary&SearchIndex=Beauty&Service=AWSECommerceService&Timestamp=#{timestamp}"
    data = ['GET', 'webservices.amazon.com', '/onca/xml', query].join("\n")
    sha256 = OpenSSL::Digest::SHA256.new
    sig = OpenSSL::HMAC.digest(sha256, ENV['AWS_SECRET_ACCESS_KEY'].strip, data)
    signature = CGI.escape(Base64.encode64(sig).strip)
    rlt = "https://webservices.amazon.com/onca/xml?" + query + "&Signature=#{signature}"
  end

  def self.generate_product_object(data, item_page, restrict_value)

    if data["Request"]["IsValid"] == "False" || data["Request"]["Errors"]
      rlt = {error: [data["Request"]["IsValid"], data["Request"]["Errors"]["Error"]["Message"]]}
    else
      current_page = item_page
      total_pages = data["TotalPages"]

      products_group = [];

      if data["Item"].is_a?(Array)
        data["Item"].each { |x|
          item = {
            :id => x["ASIN"],
            :manufacturer => x["ItemAttributes"]["Manufacturer"],
            :title => x["ItemAttributes"]["Title"],
            :image_full_url => x["LargeImage"] ? x["LargeImage"]["URL"] : nil,
            :image_thumb_url => x["SmallImage"]? x["SmallImage"]["URL"] : nil,
            :price => x["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
          }

          # intercept product images to be used at shopping cart
          update_shopping_product_image item[:id], item[:image_full_url], item[:image_thumb_url]

          if restrict_value == 0
            if item[:title].downcase.exclude?("weave") && item[:title].downcase.exclude?("wig") && item[:title].downcase.exclude?("accessory") && item[:title].downcase.exclude?("accessories") && item[:title].downcase.exclude?("extension") && item[:title].downcase.exclude?("remy") && item[:title].downcase.exclude?("brazilian") && item[:title].downcase.exclude?("virgin") && item[:title].downcase.exclude?("human") && item[:title].downcase.exclude?("bundle") && item[:title].downcase.exclude?("braid") && item[:title].downcase.exclude?("clip in") && item[:title].downcase.exclude?("hairpiece")
              products_group.push item
            end
          else
            products_group.push item
          end
        }
      else
        item = {
          :id => data["Item"]["ASIN"],
          :manufacturer => data["Item"]["ItemAttributes"]["Manufacturer"],
          :title => data["Item"]["ItemAttributes"]["Title"],
          :image_full_url => data["Item"]["LargeImage"] ? data["Item"]["LargeImage"]["URL"] : nil,
          :image_thumb_url => data["Item"]["SmallImage"]? data["Item"]["SmallImage"]["URL"] : nil,
          :price => data["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
        }
        # intercept product images to be used at shopping cart
        update_shopping_product_image item[:id], item[:image_full_url], item[:image_thumb_url]

        if restrict_value == 0
          if item[:title].downcase.exclude?("weave") && item[:title].downcase.exclude?("wig") && item[:title].downcase.exclude?("accessory") && item[:title].downcase.exclude?("accessories") && item[:title].downcase.exclude?("extension") && item[:title].downcase.exclude?("remy") && item[:title].downcase.exclude?("brazilian") && item[:title].downcase.exclude?("virgin") && item[:title].downcase.exclude?("human") && item[:title].downcase.exclude?("bundle") && item[:title].downcase.exclude?("braid") && item[:title].downcase.exclude?("clip in") && item[:title].downcase.exclude?("hairpiece")
            products_group.push item
          end
        else
          products_group.push item
        end
      end

      rlt = {
        :current_page => current_page,
        :total_pages => total_pages,
        :products => products_group,
      }
    end

    rlt
  end

  def self.update_shopping_product_image(asin, image_full_url, image_thumb_url)
    UpdateShoppingProductImage.call(asin: asin, image_full_url: image_full_url,
      image_thumb_url: image_thumb_url)
  end
end
