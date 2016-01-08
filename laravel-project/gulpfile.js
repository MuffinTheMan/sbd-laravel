var elixir = require('laravel-elixir');

/*
 |--------------------------------------------------------------------------
 | Elixir Asset Management
 |--------------------------------------------------------------------------
 |
 | Elixir provides a clean, fluent API for defining some basic Gulp tasks
 | for your Laravel application. By default, we are compiling the Sass
 | file for our application, as well as publishing vendor resources.
 |
 */

// For minification, run gulp --production (or individually as seen below)
// gulp sass --production
elixir(function(mix) {
    mix.sass('app.scss', null, {includePaths: ["vendor/zurb/foundation/scss"]});
});

// gulp version --production
elixir(function(mix) {
    mix.version('css/app.css');
});