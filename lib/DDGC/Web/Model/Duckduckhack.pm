package DDGC::Web::Model::Duckduckhack;

use Moose;
extends 'Catalyst::Model';

use Catalyst::Utils;
use Text::Markdown;
use IO::All;
use Net::GitHub::V3;
use File::Basename;
use MIME::Base64;
use Data::Dumper;

sub get_docs {

	my ($self, $doc) = @_;

	my $gh = Net::GitHub::V3->new( access_token => "2e8cfc531d454e171591a8f901e908735ba82d6b" );
	$gh->set_default_user_repo('duckduckgo', 'duckduckgo-documentation');
	my $git_data = $gh->git_data;
	my $trees = $git_data->trees("master");
	my @files = map { $_ } grep { $_->{type} eq "blob" } @{$trees->{tree}};

	my %tree;
	my $contents = {};

	for my $file (@files) {
		my $path = $file->{path};
		my $url = $file->{url};
		my $fname = basename($path);
		next unless $fname =~ /\.md$/;

		# Borrowed these 3 lines from online
		# Recreates directory structure from file paths
		my @parts = split /\//, $path;
		my $scan = \%tree;
		$scan = $scan->{shift @parts} ||= {} while @parts;
		
		my $blob = $git_data->blob($file->{sha});
		my $decoded = decode_base64($blob->{content});
		my $contents->{$fname} = $decoded;
		warn "$fname - Got that one!";
	}
	
	warn Dumper $contents;
	
	my $result = $contents->{$doc} || $contents;
	return \$result;
}

no Moose;
__PACKAGE__->meta->make_immutable;