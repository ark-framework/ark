requires 'Plack';
requires 'Plack::Request';
requires 'Cookie::Baker';
requires 'Mouse',       '1.0';
requires 'Try::Tiny',   '0.02';
requires 'Path::Class', '0.16';
requires 'URI';
requires 'URI::WithBase';
requires 'Text::MicroTemplate';
requires 'Text::SimpleTable';
requires 'Module::Pluggable::Object';
requires 'Data::Util';
requires 'Class::Data::Inheritable';
requires 'HTML::Entities';
requires 'HTTP::Cookies';
requires 'HTTP::Message';
requires 'Data::UUID';
requires 'Digest::SHA1';
requires 'Devel::StackTrace';
requires 'Exporter::AutoClean';
requires 'Object::Container' => '0.08';
requires 'Path::AttrRouter'  => '0.03';

# build-in form generator/validator
requires 'HTML::Shakan' => '0.16';
requires 'FormValidator::Lite';
requires 'Clone';

#feature 'MT', 'Support MicroTemplate template engine' => sub {
    recommends 'Text::MicroTemplate::Extended' => '0.09';
#};

#feature 'DBIC', 'Support DBIx::Class OR Mapper' => sub {
    recommends 'DBIx::Class';
    recommends 'DBD::SQLite';
#};

#feature 'OpenID', 'Support OpenID Authentication' => sub {
    recommends 'Net::OpenID::Consumer';
    recommends 'LWPx::ParanoidAgent';
#};

#feature 'I18N', 'Support I18N' => sub {
    recommends 'Locale::Maketext::Lexicon';
    recommends 'Locale::Maketext::Simple';
#};

#feature 'Mobile', 'Support Mobile App' => sub {
    recommends 'Encode::JP::Mobile';
    recommends 'HTTP::MobileAgent';
    recommends 'HTTP::MobileAgent::Plugin::Charset';
    recommends 'OAuth::Lite';
#};

on develop => sub {
    requires 'Module::Install';
    requires 'Module::Install::AuthorTests';
    requires 'Module::Install::ReadmeMarkdownFromPod';
    requires 'Module::Install::CPANfile';
};

on test => sub {
    requires 'Test::More' => '0.98';
    requires 'Test::Output';
    requires 'HTTP::Cookies';
};
