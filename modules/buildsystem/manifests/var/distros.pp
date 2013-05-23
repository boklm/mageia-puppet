# $distros:
#   a hash variable containing distributions informations indexed by
#   distribution name. Each distribution is itself an hash containing
#   the following keys:
#     - medias: an hash containing the different medias / repositories
class buildsystem::var::distros(
    $distros
) { }
