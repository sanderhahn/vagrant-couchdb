# Readme

```sh
vagrant up
```

Visit [http://localhost:5984/_utils/](http://localhost:5984/_utils/) for Futon or [http://localhost:5984/_utils/fauxton/](http://localhost:5984/_utils/fauxton/) for Fauxton.

# Enable CORS

```sh
export HOST=http://admin:password@couchdb:5984
curl -X PUT $HOST/_config/httpd/enable_cors -d '"true"'
curl -X PUT $HOST/_config/cors/origins -d '"*"'
curl -X PUT $HOST/_config/cors/credentials -d '"true"'
curl -X PUT $HOST/_config/cors/methods -d '"GET, PUT, POST, HEAD, DELETE"'
curl -X PUT $HOST/_config/cors/headers -d '"accept, authorization, content-type, origin"'
```
