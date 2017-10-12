# README

You will be given dump of PostgreSQL(9.6) database. We don't want you to
lose too much time so ~3 hours should be enough, if you don't finish the
task in 3 hours don't continue to work on it and just publish what you
have.

**Restoring database:**

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U yourpostgresuser -d store_development store.pgdb
```

[Link to database][1]

**Task**:

Create web application for given DB.
Normalize DB.

Implement next REST methods:

* `/books` – return all books
  - `/books/prime` – return list of books where name size is prime number
* `/articles` – return all articles
* `/search/filter` – find books and articles by specific parameters
  - Parameters:
    - *Name* – book or article name
    - *Genre* – genre name
    - *Author* – author name
    - *Publisher* – publisher name

* `/lists/books` – return list of available top 5 books for discount lists

*Questions to ask yourself*:

* Why did you choose a given technology?
* Do you know any better options?
* What are the limitations?
* What kind of choices did you make or avoided?
* Patterns?
* Best Practices?
* Document any side effects and possible problems when scaling up the
  application (can be in points we will talk about that during our
  interview).


# Start Project

```
rails new search_params --skip-yarn --skip-keeps --skip-action-mailer --skip-action-cable --skip-test --skip-system-test --api -d postgresql

rails g model Book name available:boolean genres authors publisher
rails g model Article name body:text authors genres
rails g model List name
rails g model SingleSort list:belongs_to:index book:belongs_to:index position:integer

rails g controller Books index
rails g controller Articles index
rails g controller Lists books
```
Edit `config/routes.rb`:

```
Rails.application.routes.draw do

  root to: 'books#index'

  # match '/list/books', to: 'books#index', via: :get

  get 'lists/books'

  resources :books, only: [:index, :show] do
    get 'search', on: :collection
  end

  resources :articles, only: [:index, :show] do
    get 'search', on: :collection
  end
end
```

```
rake db:create
rake db:migrate
rake db:migrate:status

database: store_development

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20171005065441  Create books
   up     20171005065449  Create articles
   up     20171005065455  Create lists
   up     20171005065503  Create single sorts


mv db/migrate/20171005065441_create_books.rb          public/
mv db/migrate/20171005065449_create_articles.rb       public/
mv db/migrate/20171005065455_create_lists.rb          public/
mv db/migrate/20171005065503_create_single_sorts.rb   public/

rake db:migrate:status

database: store_development

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20171005065441  ********** NO FILE **********
   up     20171005065449  ********** NO FILE **********
   up     20171005065455  ********** NO FILE **********
   up     20171005065503  ********** NO FILE **********

bash> psql
kapranov=# \l
kapranov=# \c store_development

store_development=# \dt

          List of relations
 Schema |         Name         | Type  |  Owner
--------+----------------------+-------+----------
 public | ar_internal_metadata | table | kapranov
 public | articles             | table | kapranov
 public | books                | table | kapranov
 public | lists                | table | kapranov
 public | schema_migrations    | table | kapranov
 public | single_sorts         | table | kapranov

store_development=# select * from schema_migrations;

    version
----------------
 20171005065441
 20171005065449
 20171005065455
 20171005065503

bash> pg_restore --verbose --clean --no-acl --no-owner -h localhost -U kapranov -d store_development store.pgdb

store_development=# select * from schema_migrations;

    version
----------------
 20170402170824
 20170402171117
 20170402173107
 20170402172753

rake db:migrate:status

database: store_development

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20170402170824  ********** NO FILE **********
   up     20170402171117  ********** NO FILE **********
   up     20170402172753  ********** NO FILE **********
   up     20170402173107  ********** NO FILE **********
```

Edit controllers 'app/controllers/*':

```
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    render json: @articles.to_json
  end

  def show
    @article = Article.find(params[:id])
    render json: @article
  end

  def search
    filter = params[:filter] || nil
    articles = []
    articles = Article.where('name LIKE ?'\
                             'OR authors LIKE ? '\
                             'OR genres LIKE ?'\
                             , "%#{filter}%", "%#{filter}%", "%#{filter}%") if filter
    render json: articles
  end
end

class BooksController < ApplicationController
  def index
    @books = Book.all
    render json: @books
  end

  def show
    @book = Book.find(params[:id])
    render json: @book
  end

  def search
    filter = params[:filter] || nil
    books = []
    books = Book.where('name LIKE ?'\
                       'OR authors LIKE ? '\
                       'OR genres LIKE ?'\
                       'OR publisher LIKE ?'\
                       , "%#{filter}%", "%#{filter}%", "%#{filter}%", "%#{filter}%") if filter
    render json: books
  end
end

class ListsController < ApplicationController
  def books
    #@lists = Book.order("available DESC").limit(5)
    #@lists = Book.limit(5).order('available DESC').pluck(:available)
    @lists = Book.reorder('available desc').limit(5)
    #@lists = List.find(154).books.limit(5)
    #@lists = List.order("name DESC").limit(5)
    render json: @lists
  end
end
```

Edit models `app/models/*`:

```
class Article < ApplicationRecord
  validates_presence_of :name, :body, :genres, :authors
end

class Book < ApplicationRecord
  has_many :single_sorts
  has_many :lists, through: :single_sorts

  validates_presence_of :name, :genres, :authors, :publisher
  validates_inclusion_of :available, :in => [true, false]
end

class List < ApplicationRecord
  has_many :single_sorts
  has_many :books, through: :single_sorts, source: :book

  validates_presence_of :name
end

class SingleSort < ApplicationRecord
  belongs_to :book
  belongs_to :list

  validates_presence_of :book_id, :list_id, :position
  validates_uniqueness_of :book_id, scope: :list_id
end
```

Edit serializers 'app/serializers/*':

```
class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :genres, :authors
end

class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :available, :genres, :authors, :publisher
end

class ListSerializer < ActiveModel::Serializer
  attributes :name
end
```

**Usage searching for Articles and Books**:

```
http :3000
http :3000/books
http :3000/articles

# search for books: "name","authors","genres", "publisher"
http :3000/books/search?filter='After Many a Summer Dies the Swan'
http :3000/books/search?filter='Zion Lang, Stephan Shanahan'
http :3000/books/search?filter='Tall tale'
http :3000/books/search?filter='No Starch Press'

# search for articles: "name","authors","genres"
http :3000/articles/search?filter='Laudantium Reiciendis Alias Ea'
http :3000/articles/search?filter='Dr. Marlene Christiansen'
http :3000/articles/search?filter='Metafiction'
```

**Create list of available top 5 books for discount lists `/lists/books`**:

```
http :3000/lists/books
```

### 4 October 2017 Oleg G.Kapranov

[1]: https://drive.google.com/a/roundforest.com/file/d/0B0UMlg1X-JroOVFtOUkwZEJhRzQ/view?usp=sharing
[2]: http://www.bentedder.com/creating-a-basic-autocomplete-search-endpoint-in-ruby-on-rails/
