# Geolocation

## Features:
- Basic authentication (no JWT or even Devise overkill)
- Clean code, flexible for new data vendors, and extensible for scaling up
- Ability to create, show, and destroy locations based of identifier (IP address or URL)
  
The application can be tested running the spec files, with the API responses having been recorded into VCR gem's cassettes.
To test on a local development server, add an .env file at the root of the project with this inside (or whatever key you want) `IPSTACK_API_KEY=1608c7bd2638ea18112214bc68a903c4`

From there:

1) Set up the database `rails db:create db:migrate db:seed`
2) Start a server: `rails s`
3) `db:seed` guarenteed there's a user set up. to get your credentials `rails c` and then `User.last.api_key` (or create your own)
4) Use an API endpoint that can be interacted using standard cURL:

`locations#create`
```shell
curl "localhost:3000/locations/" -d '{"identifier":"www.yahoo.com"}' -X "POST" -H "Content-Type: application/json" -H "Bearer: sometoken"
```
`locations#show`
```shell
curl "localhost:3000/locations/www.yahoo.com" -H "Content-Type: application/json" -H "Bearer: sometoken"
```
`locations#destroy`
```shell
curl "localhost:3000/locations/www.yahoo.com" -X "DELETE" -H "Content-Type: application/json" -H "Bearer: sometoken"
```
