package Angelos::I18N::Localizer::Role;
use Angelos::Role;
requires 'loc', 'loc_lang';

has 'po_dir' => (
    is       => 'rw',
    required => 1,
);

1;
