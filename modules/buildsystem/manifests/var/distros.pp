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
#      },
#    }
class buildsystem::var::distros(
    $default_distro,
    $distros
) { }
