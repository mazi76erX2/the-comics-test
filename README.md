# The Comics Test
An HTML page that displays a superhero's story and the characters featured in it from Marvel comics.

## Usage
* Clone repo locally and install backend dependencies
Make sure you have ruby 3.1.2 or later installed, Rails 7.0.0 or later as well as the gem package 'bundle'. Clone the repo and then run the following commands:

```bash
bundle install
```

* Add a file called `local_env.yml` in the `config` folder with the following in the file:

```bash
MARVEL_PUBLIC_KEY: "<YOUR_PUBLIC_KEY>"
MARVEL_PRIVATE_KEY: "<YOUR_PRIVATE_KEY>"
```
* Run Rails on your local server

```bash
rails s
```

* Open http://127.0.0.1:3000/ in your browser.

![Home page](example_files/home_page.png)
