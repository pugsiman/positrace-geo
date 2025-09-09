# Geolocation

### Features
- Basic authentication (no JWT or even Devise overkill)
- Clean code, flexible for new data vendors, and extensible for scaling up
- Ability to create, show, and destroy locations based on identifier (IP address or URL)
- Utilizes PostGIS (and GiST indices)
- Flexible design acknowledging that the same IP address (or URL) may resolve to different physical locations over time
  
To test on a local development server, add an .env file at the root of the project with this inside (or whatever key you want) `IPSTACK_API_KEY=1608c7bd2638ea18112214bc68a903c4`

From there:

1) Set up the database `rails db:create db:migrate db:seed` (seed will create a user for you)
2) Start a server: `rails s`
3) To get your credentials `rails c` and then `User.last.api_key` (or create your own)

`locations#create`
```shell
curl "localhost:3000/api/v1/locations/" -d '{"identifier":"www.yahoo.com"}' -X "POST" -H "Content-Type: application/json" -H "Authorization: Bearer youtoken"
```
`locations#show`
```shell
curl "localhost:3000/api/v1/locations/www.yahoo.com" -H "Content-Type: application/json" -H "Authorization: Bearer yourtoken"
```
`locations#destroy`
```shell
curl "localhost:3000/api/v1/locations/www.yahoo.com" -X "DELETE" -H "Content-Type: application/json" -H "Authorization: Bearer yourtoken"
```
