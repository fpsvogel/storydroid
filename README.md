<h1 align="center">🤖 Story Droid 🤖</h1>
<p align="center">└[∵┌]└[ ∵ ]┘[┐∵]┘</p>

Welcome to the [Story Droid](https://storydroid.herokuapp.com/) codebase. I built this little app as an experiment which [I wrote about on my blog](https://fpsvogel.com/posts/2021/gpt3-ai-story-writer).

### Table of Contents

- [Inspiration: Why stories?](#inspiration-why-stories)
- [Contributing](#contributing)
- [Requirements](#requirements)
- [Initial setup](#initial-setup)
- [License](#license)

## Inspiration: Why stories?

The GPT-3 API [is now in open beta](https://beta.openai.com) and I wanted to play around with it after I stumbled upon some neat AI story generators:

- https://sassbook.com/ai-writer
- https://play.aidungeon.io/main/home
- https://www.deepstory.ai/#!/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fpsvogel/storydroid.

## Requirements

- Ruby 3+
- Node.js 14+
- PostgreSQL 9.3+

## Initial setup

- Checkout the storydroid git tree from Github:
    ```sh
    $ git clone git://github.com/fpsvogel/storydroid.git
    $ cd storydroid
    storydroid$
    ```
- Run Bundler to install gems needed by the project:
    ```sh
    storydroid$ bundle
    ```
- Log in to PostgreSQL and create a user:
    ```
    $ psql -U postgres
    postgres=# create role "your_username" login createdb
    postgres=# exit
    ```
- Create the development and test databases:
    ```sh
    storydroid$ rails db:create
    ```
  - If you see an error about peer authentication, then you need to [change one or two settings in pg_hba.conf](https://stackoverflow.com/questions/18664074/getting-error-peer-authentication-failed-for-user-postgres-when-trying-to-ge), then try creating the databases again.
- Load the schema into the new database:
    ```sh
    storydroid$ rails db:schema:load
    ```
- Seed the database:
    ```sh
    storydroid$ rails db:seed
    ```

## License

Distributed under the [MIT License](https://opensource.org/licenses/MIT).
