# $default_distro:
#   the name of the default distribution
# $distros:
#   a hash variable containing distributions informations indexed by
#   distribution name. Each distribution is itself an hash containing
#   the following infos:
#    {
#      # the 'cauldron' distribution
#      'cauldron' => {
#         # list of arch supported by 'cauldron'
#         'arch' => [ 'i586', 'x86_64' ],
#         'medias' => {
#            # the 'core' media
#            'core' => {
#               'repos' => {
#                 # the 'release' repo in the 'core' media
#                 'release' => {
#                    'media_type' => [ 'release' ],
#                    'noauto' => '1',
#                 },
#                 # the 'updates' repo
#                 'release' => {
#                    'media_type' => [ 'updates' ],
#                    'noauto' => '1',
#                    # the 'updates' repo requires the 'release' repo
#                    'requires' => [ 'release' ],
#                 },
#               },
#               # media_type for media.cfg
#               'media_type' => [ 'official', 'free' ],
#               # if noauto is set to '1' either in medias or repos,
#               # the option will be added to media.cfg
#               'noauto' => '1',
#            },
#            # the 'non-free' media
#            'non-free' => {
#               'repos' => {
#                     ...
#               },
#               'media_type' => [ 'official', 'non-free' ],
#               # the 'non-free' media requires the 'core' media
#               'requires' => [ 'core' ],
#            }
#         },
#         # the list of media used by iurt to build the chroots
#         'base_medias' => [ 'core/release' ],
#         # optionally, a media.cfg template file can be specified, if
#         # the default one should not be used
#         'tmpl_media.cfg' => 'buildsystem/something',
#         # branch is Devel or Official. Used in media.cfg.
#         'branch' => 'Devel',
#         # Version of the distribution
#         'version' => '3',
#         # SVN Urls allowed to submit
#         'submit_allowed' => 'svn://svn.something/svn/packages/cauldron',
#         # rpm macros to set when build source package
#         'macros' => {
#            'distsuffix' => '.mga',
#            'distribution' => 'Mageia',
#            'vendor' => 'Mageia.Org',
#         },
#         # list of IP or hostnames allowed to access this distro on the
#         # repository. If you don't want to filter allowed IPs, don't set
#         # this value
#         'repo_allow_from' => [ '127.0.0.1', '10.0.0.1', '.mageia.org' ],
#         Optionally, the distribution can be based on the repos from an other
#         distribution. In this example we're saying that the distribution is
#         based on 2/core/release and 2/core/updates.
#         'based_on' => {
#            '2' => {
#                'core' => [ 'release', 'updates' ],
#            },
#         },
#         'youri' => {
#            # Configuration for youri-upload
#            'upload' => {
#                # list of enabled checks, actions and posts
#                'targets' => {
#                    'checks' => [
#                        ...
#                    ],
#                    'actions' => [
#                        ...
#                    ],
#                    'posts' => [
#                        ...
#                    ],
#                },
#                'checks' => {
#                    # rpmlint checks options
#                    'rpmlint' => {
#                        'config' => '/usr/share/rpmlint/config',
#                        'path' => ''/usr/bin/rpmlint',
#                    },
#                },
#                # options for actions
#                'actions' => {
#                    ...
#                },
#            },
#            # Configuration for youri-todo
#            'todo' => {
#                ...
#            },
#         },
#      },
#    }
class buildsystem::var::distros(
    $default_distro,
    $distros
) { }
