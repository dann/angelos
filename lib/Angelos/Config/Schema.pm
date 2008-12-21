package Angelos::Config::Schema;

sub config {
    my $schema = {
        type => 'map',

        mapping => {
            components => {
                type    => 'map',
                mapping => {
                    model => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    controller => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    view => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                }
            },
            plugins => {
                type    => 'map',
                mapping => {
                    model => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    controller => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    view => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                }
            },
            middlewares => {
                type     => 'seq',
                sequence => [
                    {   type    => 'map',
                        mapping => {
                            module => { type => 'str', required => 1, },
                            config => { type => 'any', },
                        },
                    },
                ],
            },
        },
    };
    $schema;
}

sub routes {
    # TODO define routes schema
}

1;
