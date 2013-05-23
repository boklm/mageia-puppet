# $distros:
#   a hash variable containing distributions informations indexed by
#   distribution name. Each distribution is itself an hash containing
#   the following keys:
#     - medias: an hash containing the different medias / repositories
#     - base_media: a list of medias that will be used by iurt to build
#       the chroots
class buildsystem::var::distros(
    $distros
) { }
