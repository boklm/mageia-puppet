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
#                 'release' => {},
#               },
#            },
#         },
#         # the list of media used by iurt to build the chroots
#         'base_medias' => [ 'core/release' ],
#      },
#    }
class buildsystem::var::distros(
    $distros
) { }
