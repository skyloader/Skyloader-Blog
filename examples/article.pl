#!/usr/bin/env perl

use 5.010;
use utf8;
use strict;
use warnings;

use File::Slurp;

use Skyloader::Blog::Article;

my $sba = Skyloader::Blog::Article->new(
    directory => '/Users/jaeminchoi/workspace/blog',
);

#
# get full path of year 2012 articles
#
{
    my $articles = $sba->year(2012);
    for my $article (@$articles) {
        my $content = read_file($article);
        say "path: $article";
        say $content;
        say '-' x 72;
    }
}

#
# get full path of month 8 year 2012 articles
#
{
    my $articles = $sba->month(2012, 8);
    for my $article (@$articles) {
        my $content = read_file($article);
        say "path: $article";
        say $content;
        say '-' x 72;
    }
}

#
# get full path of dsy 15 month 8 year 2012 articles
#
{
    my $articles = $sba->day(2012, 8, 15);
    for my $article (@$articles) {
        my $content = read_file($article);
        say "path: $article";
        say $content;
        say '-' x 72;
    }
}

#
# get full path of articles with subject
#
{
    my $articles = $sba->subject('find_me');
    for my $article (@$articles) {
        my $content = read_file($article);
        say "path: $article";
        say $content;
        say '-' x 72;
    }
}

#
# get full path of articles with subject and date
#
{
    my $articles = $sba->subject('find_me', 2012, 8, 15);
    for my $article (@$articles) {
        my $content = read_file($article);
        say "path: $article";
        say $content;
        say '-' x 72;
    }
}

#
# get full path of articles with specific keyword
#
{
    my $articles = $sba->search('테스트');
    for my $article (@$articles) {
        my $content = read_file($article);
        say "path: $article";
        say $content;
        say '-' x 72;
    }
}
__DATA__

