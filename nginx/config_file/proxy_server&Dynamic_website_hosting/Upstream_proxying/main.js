var http= require ('http');
  http.createServer(function(request,response){
     response.writeHead(200, {'Content-Type': 'text/plain'});
     response.end('Welcome to techie node JS base website !'); 
  }).listen(8080);
  
console.log ('Server Running at http://127.0.0.1:8080/')