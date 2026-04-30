#!/usr/bin/env perl

use strict;
use warnings;
use File::Path qw(remove_tree make_path);
use Getopt::Long;

my $clean = 0;

GetOptions(
    "clean"     => \$clean,
) or die "Invalid flags. Use -h for help";

sub command {
    my ($name) = @_;
    my @path = split(":", $ENV{PATH});
    foreach (@path) {
        if (-f "$_/$name") {
            return $name;
        }
    }
    return 0;
}

my $container_name = "antora/antora";
my $playbook = "site.yml";

my $engine = command("podman");
$engine = command("docker") unless $engine;

my @cmd = (
    $engine, "run",
        "-v", sprintf("%s:%s:Z", $ENV{PWD}, "/antora"),
        "--rm",
        "-t", $container_name,
        $playbook,
);
push @cmd, "-u", sprintf("%s:%s", `id -u`, `id -g`) if $engine =~ /docker/;
push @cmd, @ARGV if @ARGV;

if ($clean) {
    remove_tree "build" if -d "build";
    remove_tree "cache" if -d "cache";
}
print "@cmd\n";
system @cmd;
