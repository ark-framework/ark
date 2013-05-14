on develop => sub {
    requires 'Module::Install';
    requires 'Module::Install::AuthorTests';
    requires 'Module::Install::CPANfile';
};

on test => sub {
    requires 'Test::More' => '0.96';
    requires 'Test::Output';
};

requires 'Plack';
requires 'Plack::Request';
requires 'CGI::Simple';
requires 'Mouse'   => '1.0';
requires 'Try::Tiny' => '0.02';
requires 'Path::Class'  => '0.16';
requires 'URI';
requires 'URI::WithBase';
requires 'Text::MicroTemplate';
requires 'Text::SimpleTable';
requires 'Module::Pluggable::Object';
requires 'Data::Util';
requires 'Class::Data::Inheritable';
requires 'HTML::Entities';
requires 'Data::UUID';
requires 'Digest::SHA1';
requires 'Devel::StackTrace';
requires 'Exporter::AutoClean';
requires 'Object::Container' => '0.08';
requires 'Path::AttrRouter'  => '0.03';

# build-in form generator/validator
requires 'HTML::Shakan' => '0.16';
requires 'Clone';
