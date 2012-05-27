class buildsystem::config(
    architectures = ['i586', 'x86_64'],
    dev_distros = ['cauldron'],
    stable_distros = ['1', '2'],
    distrosections = ['core', 'nonfree', 'tainted'],
    sectionsrepos = ['release', 'updates', 'updates_testing', 'backports',
    		     'backports_testing']
)
{
}
