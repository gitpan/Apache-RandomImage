# $Id: RandomImage.pm,v 1.3 2003/11/04 11:50:00 c102mk Exp $
package Apache::RandomImage;

use strict;

use Apache::Constants qw(OK NOT_FOUND DECLINED);
use DirHandle;

use vars qw/$VERSION/;
BEGIN {
    $VERSION = 0.01;
}

sub handler {
    my $r = shift;
    my $uri = $r->uri;
    $uri =~ s|[^/]+$||;

    my $dir = $r->document_root . $uri;
    my $dh = DirHandle->new($dir);
    unless ($dh) {
        $r->log_error("Cannot open directory $dir: $!");
        return NOT_FOUND;
    }

    my @suffixes = split('\s+',$r->dir_config("Suffixes"));
    return DECLINED unless scalar @suffixes;

    my @images;
    foreach my $file ($dh->read) {
        next unless grep { $file =~ /\.$_$/i } @suffixes;
        push (@images, $file);
    }

    return NOT_FOUND unless scalar @images;

    my $image = $images[rand @images];
    $r->internal_redirect_handler("$uri/$image");

    return OK;
}


1;

__END__

=head1 NAME

Apache::RandomImage - Lightweight module to randomly display images from a directory.

=head1 SYNOPSIS

  You can use this in your Apache *.conf or .htaccess files to activate this module.

<LocationMatch "^/(.+)/images/random-image">
    SetHandler perl-script
    PerlSetVar Suffixes "gif png jpg"
    PerlHandler Apache::RandomImage
</LocationMatch>

<Location "/images/give-random">
    SetHandler perl-script
    PerlSetVar Suffixes "gif png jpg tif jpeg"
    PerlHandler Apache::RandomImage
</Location>

=head1 DESCRIPTION

Apache::RandomImage will randomly select an image from the dirname of the requested location.
You need to specify a white-space separated list of B<Suffixes> with I<PerlSetVar>,
otherwise the request will be declined.

=head1 AUTHORS

Michael Kröll <michael.kroell@uibk.ac.at>

=head1 SEE ALSO

perl(1), Apache(3), mod_perl(3), Apache::RandomLocation(3)


=head1 COPYRIGHT

Copyright 2003, Michael Kröll

This package is free software and is provided "as is" without express
or implied warranty. It may be used, redistributed and/or modified
under the same terms as Perl itself.

=cut

