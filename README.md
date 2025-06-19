# Deputados Gastos

### Context

Deputados Gastos is a learning purpose application. The objective of this application is monitor the spending of parliamentarians from all Brazilian states. Remembering that these expenses are public money. The user who wants to check these expenses, only needs to get the csv file from the government website, and import the file into the main page.

### Online version

You can access the Heroku hosted version by [clicking here](https://deputados-gastos-99f3d7eec48d.herokuapp.com/)

### Functionalities

#### The app has the following features:

* Uploading a CSV file with parliamentary spending data
* Listing of deputies filtered by state
* Displaying total spending by deputy
* Detailed individual expenses
* Pie chart showing the parties that spent the most in the state
* Uploading new CSVs via the interface
* JSON responses available for data endpoints (API)

### Technologies

#### List of technologies used in the project:

* Ruby 3.3.5
* Rails 7 (full usage, without the --api flag)
* PostgreSQL (database)
* Bootstrap 5 (front-end style)
* Chartkick + Chart.js (for rendering charts)
* RSpec (tests)


### Running the project locally

First of all, different from the previous list, which mentioned all the technologies used in the project, this is the list of the technologies that you need to install in your system to be able to run the project:

* Ruby 3.3.5
* Rails 7
* PostgreSQL 12+
* Node.js (NVM recommended)

After installing the technologies, let’s clone the project:

```bash
git clone https://github.com/seu-usuario/deputados-gastos.git
cd deputados-gastos
```

Install the dependencies:

```bash
bundle install
```

Create the database:

```bash
rails db:create db:migrate
```

Then run the rails server:

```bash
rails s
```

And now you can access your local application at `http://localhost:3000/`

# API Endpoints

### GET 'deputados(/:uf)'

Returns the list of parliamentarians from a specific state.

#### Parameters

* **`uf`** (**mandatory**) : state acronym (example: `RJ`, `SP`, `BA`)

#### Request example

```bash
GET /deputados?uf=RJ
```

#### Response example

```json
[
  {
    "id": 1,
    "nome": "Juca",
    "partido": "PL",
    "uf": "RJ",
    "total_de_gastos": 123456.78
  },
  ...
]
```

### GET 'deputado/:id/despesas'

Returns detailed expenses for a specific parliamentarian.

#### Parameters

* **`id`** (**mandatory**) : parliamentarian ID.

#### Request example

```bash
GET /deputados/1/despesas
```

#### Response example

```json
{
  "deputado": {
    "id": 1,
    "nome": "Juca",
    "partido": "PL",
    "uf": "RJ"
  },
  "despesas": [
    {
      "fornecedor": "Posto Shell",
      "data_emissao": "2023-05-02",
      "valor": 489.90,
      "url_documento": "http://camara.gov.br/doc.pdf",
      "maior_despesa": false
    },
    ...
  ]
}
```