def application(env,start_response):
     start_response('200 OK' ,[('context-Type','text/html')])
     return ["Hello TechieNode ! This is my first python Web page !!! "]