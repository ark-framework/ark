requires 'Plack', '0.9910';
requires 'Plack::Request::WithEncoding', '0.10';
requires 'Plack::Response';
requires 'Mouse',       '1.0';
requires 'Try::Tiny',   '0.02';
requires 'Path::Class', '0.16';
requires 'URI';
requires 'URI::WithBase';
requires 'Module::Pluggable::Object';
requires 'Class::Data::Inheritable';
requires 'Data::UUID';
requires 'Data::Util';
requires 'Digest::SHA1';
requires 'Object::Container' => '0.08';
requires 'Exporter::AutoClean';
requires 'Path::AttrRouter'  => '0.03';

# Ark::Test
requires 'HTTP::Cookies';
requires 'HTTP::Message';

# Context::Debug
requires 'Devel::StackTrace';
requires 'HTML::Entities';
requires 'Text::SimpleTable';
requires 'Text::MicroTemplate';

# build-in form generator/validator
requires 'HTML::Shakan' => '0.16';
requires 'FormValidator::Lite';
requires 'Clone';

recommends 'Text::Xslate';
recommends 'Text::MicroTemplate::Extended' => '0.09';

#feature 'I18N', 'Support I18N' => sub {
    recommends 'Locale::Maketext::Lexicon';
    recommends 'Locale::Maketext::Simple';
#};

on test => sub {
    requires 'Test::More' => '0.98';
    requires 'Test::Output';
    requires 'Test::Requires';
};
