package Skyloader::Blog::Article;

use utf8;
use strict;
use warnings;

use Encode qw( decode_utf8 );
use File::Spec;

my %DEFAULT_CONFIG = (
    directory => 'blog',
);

sub new {
    my ( $class, %params ) = @_;

    my $self = bless {
        %DEFAULT_CONFIG,
        %params,
    }, $class;

    return $self;
}

sub directory {
    my ( $self, $directory ) = @_;

    if ($directory) {
        $self->{directory} = $directory;
    }

    return $self->{directory};
}

sub year {
    my ( $self, $year ) = @_;

    return unless $year;

    return $self->_get_articles_by( year => $year, );
}

sub month {
    my ( $self, $year, $month ) = @_;

    return unless $year;
    return unless $month;

    return $self->_get_articles_by(
        year  => $year,
        month => $month,
    );
}

sub day {
    my ( $self, $year, $month, $day ) = @_;

    return unless $year;
    return unless $month;
    return unless $day;

    return $self->_get_articles_by(
        year  => $year,
        month => $month,
        day   => $day,
    );
}

sub subject {
    my ( $self, $subject, $year, $month, $day ) = @_;

    return unless $subject;

    return $self->_get_articles_by(
        subject => $subject,
        year    => $year,
        month   => $month,
        day     => $day,
    );
}

sub _get_fullpath {
    my $self = shift;

    my $paths_ref;
    opendir( my $dh, $self->directory )
        or do {
            warn "cannot open directory: " . $self->directory . "\n";
            return;
        };

    for my $year ( readdir($dh) ) {
        if ( $year =~ /\d{4}/ ) {
            for my $month (0..12) {
                $month = sprintf "%02d", $month;
                for my $day (0..31) {
                    $day = sprintf "%02d", $day;
                    my $path = File::Spec->catdir($self->directory, $year, $month, $day);
                    if ( -e $path ) {
                        push @$paths_ref, $path;
                    }
                }
            }
        }
    }
    closedir $dh;

    return  $paths_ref;
}

sub _get_articles_by {
    my ( $self, %params ) = @_;

    my $year    = $params{year};
    my $month   = $params{month};
    my $day     = $params{day};
    my $subject = $params{subject};

    my @articles;
    my $paths_ref = $self->_get_fullpath;
    return unless $paths_ref;

    for my $path (@$paths_ref) {
        my $target = File::Spec->catdir(
            $year  ? sprintf("%04d", $year)  : qr/\d{2}/,
            $month ? sprintf("%02d", $month) : qr/\d{2}/,
            $day   ? sprintf("%02d", $day)   : qr/\d{2}/,
        );

        if ( $path =~ /$target$/ ) {
            opendir(my $dh3, $path) or return;

            my $mkd_str = $subject ? qr/$subject\.mkd$/ : qr/.*\.mkd$/;
            push @articles, map File::Spec->catfile($path, $_), grep /$mkd_str/, readdir($dh3);

            closedir $dh3;
        }
    }

    return \@articles;
}

sub search {
    my ( $self, $keyword ) = @_;

    return unless $keyword;

    my @articles;
    my $mkds_ref = $self->_get_articles_by;
    for my $path (@$mkds_ref) {
        open my $fh, "<", $path or next;
        while ( <$fh> ) {
            my $line = decode_utf8($_);
            push @articles, $path and next if $line =~ /$keyword/;
        }
        close $fh;
    }

    return \@articles;
}

1;

__END__

=encoding utf-8

=head1 NAME

Skyloader::Blog::Article - Extract blog article from directory


=head1 SYNOPSIS

    my $model = Skyloader::Blog::Article->new(
        directory => '/home/skyloader/workspace/Skyloader-Blog/articles',
    );

    my $articles = $model->year(2012);
    my $articles = $model->month(2012, 8);
    my $articles = $model->day(2012, 8, 15);
    my $articles = $model->subject('intermediate-perl');
    my $articles = $model->subject('intermediate-perl', 2012, 8, 15);
    my $articles = $model->search('올림픽');


=head1 DESCRIPTION

Find the articles from Skyloader's blog repository by several keyword-like API.


=head1 METHODS

=head2 new

Create C<Skyloader::Blog::Article> object.

    my $article = Skyloader::Blog::Article->new;
    my $article = Skyloader::Blog::Article->new(
        directory => '/home/skyloader/blog',
    );


=head2 directory

get/set directory

    $article->directory('/home/skyloader/blog');
    my $directory = $article->directory;


=head2 year

Find the all articles by specific year.
This method returns a array reference.

    my $article = Skyloader::Blog::Article->new;
    my $article_year = $article->year(2012);


=head2 month

Find the all articles by specific month.
This method returns a array reference.

    my $article = Skyloader::Blog::Article->new;
    my $article_month = $article->year(2012, 08);


=head2 day

Find the all articles by specific day.
This method returns a array reference.

    my $article = Skyloader::Blog::Article->new;
    my $article_day = $article->year(2012, 08, 15);


=head2 subject

Find the articles by specific subject.
This method returns a array reference.

    my $article = Skyloader::Blog::Article->new;
    my $article_subject = $article->year('my_diary', [year], [month], [day]);


=head2 search

Find the all articles which include specific keyword.
This method returns a array reference,

    my $article = Skyloader::Blog::Article->new;
    my $article_search = $article->year('my_diary', [year], [month], [day]);


=head1 LICENSE

Same as Perl.


=head1 SEE ALSO

=over

=item Skyloader::Blog

=back


=head1 BUGS

Nothing yet


=head1 AUTHOR

Jaemin Choi, <jaemin.choi@gmail.com>


=cut
