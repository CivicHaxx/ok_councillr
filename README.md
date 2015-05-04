# OKCouncillr

![OKCouncillr](app/assets/images/logo.png)

OKCouncillor is a data scraper, API, and civic engagement app for the City of Toronto. The scraper pulls data from the City of Toronto council meetings and parses it into a database, the API serves the data up as JSON, and the app allows people to discover how their Councillor matches with their political leanings.

**Live Site: [OK Councillr](http://okcouncillr.cloudapp.net)**

## Dependencies
- [PostgreSQL](http://www.postgresql.org/)
- Ruby 2.2.2
- Rails 4.2.0

## Usage

Clone the project
`git clone git@github.com:CivicHaxx/ok_councillr.git`

`cd` into the project directory and run `bundle install`.

Run `rake db:setup` to download the City Council Agenda and votes from December 2014 to today's date and seed the database. The project currently contains a mix of real and fake data, as the scraper is continually a work in progress. 

## Contributing
We'd love to see what others can do with this project. If you'd like to contribute to this project, please fork the repo and create a pull request of your changes.

## Wish List
- Crowd-sourced synopses on each agenda item to make them more legible to the every-day person.
- Facebook OAuth so that we can do more interesting analyses of users' responses and get normalized data back from our application.
- A more robust scraper that also grabs motions from the City Council Minutes and connects these to City Councillor Votes in the database. 
- Further data analysis on the Councillor Profile pages to show:
  + % of match between the user and the Councillor.
  + Top 5 most similar and dissimilar Councillors to each Councillor.
    * This is an expansion of [Matt Elliot's Ford Nation Percentile](matt).

## Credits
This project was created by [@emilyjfan](https://github.com/emilyjfan), [@ScottKbka](https://github.com/ScottKbka), and [@SpiritBreaker226](https://github.com/SpiritBreaker226).

OKCouncillr includes code from [@jteneycke](https://github.com/jteneycke) who gave us a head start on the data scrapers, [@epitron](https://github.com/epitron) who wrote `htmlstrip` for cleaning up the agenda documents from the city, and [@csaunders](https://github.com/csaunders) who helped with refactoring the scraper and adding a MarkDown parser to clean up the front end.


[matt]: https://docs.google.com/spreadsheets/d/15MGvjaWaEZUbNk9MxTuoI_oJQ_dVFt-bOyoHHT3YFS8/edit
