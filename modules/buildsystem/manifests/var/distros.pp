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
#                    'media_types' => [ 'release' ],
#                    'noauto' => '1',
#                 },
#               },
#               # media_types for media.cfg
#               'media_types' => [ 'official', 'free' ],
#               # if noauto is set to '1' either in medias or repos,
#               # the option will be added to media.cfg
#               'noauto' => '1',
#            },
#         },
#         # the list of media used by iurt to build the chroots
#         'base_medias' => [ 'core/release' ],
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
#      },
#    }
class buildsystem::var::distros(
    $default_distro,
    $distros
) { }
