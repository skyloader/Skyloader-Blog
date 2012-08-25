#!/usr/bin/env perl

use Mojolicious::Lite;

use Skyloader::Blog::Article;

my $sba = Skyloader::Blog::Article->new(
    directory => '/Users/jaeminchoi/workspace/blog',
);

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => 'index';

get '/article/:year' => sub {
    my $self = shift;

    my $year = $self->param('year');

    my $articles = $sba->year($year);

    $self->render(
        'article',
        articles => $articles,
    );
};

get 'article/:year/:month' => sub {
    my $self  = shift;

    my $year  = $self->param('year');
    my $month = $self->param('month');

    my $articles = $sba->month( $year, $month );

    $self->render(
        'article',
        articles => $articles,
    );
};

get 'article/:year/:month/:day' => sub {
    my $self  = shift;

    my $year  = $self->param('year');
    my $month = $self->param('month');
    my $day   = $self->param('day');

    my $articles = $sba->day( $year, $month, $day );

    $self->render(
        'article',
        articles => $articles,
    );
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
Skyloader-Blog


@@ article.html.ep
% layout 'default';
% title 'Welcome';
<ul>
  % for my $article (@$articles) {
    <li> <%= $article %> </li>
  % }
</ul>


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
