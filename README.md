
Cast API v1
==

This is a readme for Cast API v1, represented in this github repository.

Version
----

1.3

Tech
-----------

### High-level project architecture review

User can register in application using email, Facebook or Amazon account. Email one is a pretty straightforward (Devise registation with frontend features disabled), while for facebook and amazon signup facebook what we do is call Facebook/Amazon API to verify that facebook/amazon token sent is valid and matches id sent, and then we create the user in database, referencing him by facebook/amazon id sent. When signing in, we validate token again the same way, and then find the user with this facebook/amazon id in database (and he is signed in successfuly than).

Every midnight we delay two rake jobs for registered users, the job is same, it's just gonna be run at different times: 9am and 12am currently. This job does the following:
1). Check the weather at current time, using user's latitude and longitude he set in his profile during sign up or profile update (for weather check we use [Barometer] gem).
2). Take user's weather, skin type, hair type, and current time - and find PushCondition, that meets those requirements. If it does - send a push note to user.

Each PushCondition has multiple PushTexts, and when sending user a push note we choose an unique one, the one, which he didn't receive yet.

### External services

This API is written primarly in Ruby on Rails. All the gems used are available via Gemfile, and here is the list of 3rd party services we use:

* **Facebook API** - used to fetch user's friends emails from his Facebook account, as well as user signup via Facebook as one of the methods (second one is emails). [Koala] gem is used for that
* **Amazon API** - this one is called via HTTParty gem, the link is like this: https://api.amazon.com/auth/O2/tokeninfo?access_token= .
Here is a good reference to Amazon API for sign up (especially be sure to check out PDF from page 17): https://images-na.ssl-images-amazon.com/images/G/01/lwa/dev/docs/website-developer-guide._TTH_.pdf

### Testing

Right now application has 59 specs, covering most of the application features (**91**% by [SimpleCov]. However, some features are not covered, so beware.
We use [VCR] gem For external API interactions, this way tests are kept determenistic and accurate. Few words about [VCR] below.

### VCR
As said above, [VCR] is used for external APIs interactions. This way we can keep them stable and determenistic (since user account info changes, as well as his friends list and count, and by keeping them determenistic it's possible to check everything better). However, it has, obviously, some pitfalls. For now we had none, but I can imagine that in future it will be required to clear some VCR cassetes in case to upgrade specs to more present state. Anyway, it didn't seem optional and even seemed obscure for me to use some real user data for specs, makes no sense. And either way protects from API changes by itself any way, so you should either check API changes from time to time, or update VCR specs cassetes sometimes, or just do E2E client testing to see if anything is missing.

##### Important VCR pitfall:
Sometimes specs can be failing cause of VCR retracking (i.e. request changed in some spec or/and some new requests added, so that requires casset to be deleted in order for request to hit the real API), but VCR error **is not shown up**, and some ruby/rails stack  backtrace is given. So beware of that in first place when working in `vcr: true` specs.

Installation
--------------

```sh
git clone git@github.com:kollectivemobile/Cast_Api.git cast_api
cd cast_api
bundle
```

After that, you should set up the `.env` environment variables. The current variables are listed at the env.sample file

Obviously, for security reasons, they are fully kept in heroku config only. For development phase we used the same ones for development as for production, so for this case we would just use `heroku config` list copied to `.env`. However, for production stage this will need some separation for services used in specs, obviously.

Then, run
```sh
be rspec
```
All the tests should be green.



License
----

All the rights belong to Sian Morson.

[Koala]:https://github.com/arsduo/koala
[Bitly]:https://bitly.com/
[SimpleCov]:https://github.com/colszowka/simplecov
[VCR]:https://github.com/vcr/vcr
[Paperclip]:https://github.com/thoughtbot/paperclip
[node.js]:http://nodejs.org
[Twitter Bootstrap]:http://twitter.github.com/bootstrap/
[keymaster.js]:https://github.com/madrobby/keymaster
[jQuery]:http://jquery.com
[@tjholowaychuk]:http://twitter.com/tjholowaychuk
[express]:http://expressjs.com
[barometer]:https://github.com/attack/barometer
