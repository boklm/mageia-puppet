
class base_packages {
    # packages installed everywhere 
    # asked by misc : screen, vim-enhanced, htop, lsof, tcpdump, less
    # asked by nanar : rsync
    $package_list = ['screen', 'vim-enhanced', 'htop', 'lsof', 'tcpdump', 'rsync', 'less']

    package { $package_list:
        ensure => installed;
    }
}

class default_ssh_root_key {
    ssh_authorized_key { "ssh key misc":
        type => "ssh-rsa",
        key => "AAAAB3NzaC1yc2EAAAABIwAAAgEA4fpjTvcL09Yzv7iV40TPjiXGHOOS5MldSh5ezSk7AMLVjAAloiidl8O3xwlxwUnjUx5zv1+RlbV76sdiSD32lBht72OZPg0UqQIB8nHeVJBdJ8YpnQ3LynNPPYJ65dvdr0uE2KRlN/1emi2N+O+f2apwc1YiL8nySEK/zLvCKO5xj16bIVuGFilDdp75X/t3C/PDsZU+CUyWL5Ly3T2+ljGc+nEAK9P0PNnvl9bRK9dqu457xjca8nXwWVI1fd6Jnt1jISFdQXy6/+9326Z6aAxvWKCrCvmdg+tAUN3fEj0WXZEPZQ1Ot0tBxKYl+xhV1Jv/ILLbInT0JZkSEKNBnJn4G7O4v+syoMqA7myHre73oGn/ocRWGJskIM33aXrJkZkJ4LkF1GLJPFI4y7bzj024sPAVvBwDrV7inwsOy0DSQ5tCbfX25TTXbK+WMXzz0pBbSi6mPgjtzlSYsLZrTa7ARYhggDG2miuOAFrup8vP7/aH2yZ+hZuF70FsMh4lf/eXDGwfypyfYrjfVSkFfY0ZU294ouTBn3HtHmgFu82vOMvLNtI9UyERluCBpLBXOT8xgM97aWFeUJEKrVxkGIiNwVNylMEYp8r16njv810NdTLA3jZu9CLueVvME6GLsGve5idtGmaYuGYNRnSRx3PQuJZl1Nj7uQHsgAaWdiM=",
        user => "root"
    }

    ssh_authorized_key { "ssh key dams":
        type => "ssh-dss",
	    key => "AAAAB3NzaC1kc3MAAACBAM+23oU9t9ghBUX2uG3hCeUwVpGoPIdnV3a8eiHf7HgUS0JqyZ/uv4LbVHyFRInt7qV4ZcChmzk6NmLfG3QnfR/3NdPJX4WxPz78BuoaI6t+fA2SdHLEY+Yz3kvI04gHuIUQ+X8e2j5wledg4r4qfkJZPCRhX1pmZFoimsCU99PJAAAAFQCOYJBWQIbV6bwtxIhj1SBR7zgA+wAAAIAA32DgUWrQUMZnXqNzo+AL/xbprE3UxEj8O2nICepTVVJboVPVek37VlKnjChl6mjya3+FkhHqfOW1UUi/L/W6C5sNsn/Ep/TxGjOLAOgG5RaXHS5RQ/Ttfs4EyPllbRmkRwCGkgx15wDo5kKuLbHCw8pLJKrxzBO4Sf6i3n4KswAAAIEAzR/EkWv6sVB6ehEO1G6L21VQQLQ7zHoJQeemuSVD6Yq8z4zcNhdrdMWZfQSiZe554G1l3lQdDmF+5kJ+1BFxXJGnZXb5/hdEBfiYeeZEQO3FvyPpnyWC73UxFksJNzFTGM8IExZ9aV4/JqdisZWMa7CRIDijeq2nQgytNcDCqRs=",
        user => "root"
    }

    ssh_authorized_key { "ssh key blino":
        type => "ssh-dss",
	    key => "AAAAB3NzaC1kc3MAAAEBAIuMeFTbzLwcxlKfqSUDmrh2lFVOZyjotQsUm4EGZIh8killmHCBmB8uYvh3ncwvcC8ZwfRU9O8jX6asKJckFIZ37cdHaTQR7fh5ozG4ab652dPND2yKCg1LCwf2x0/Ef1VtyF7jpTG/L9ZaGpeXQ8rykoH4rRnfSdYF0xT7ua9F/J/9ss5FtzQYbQLFMzV3SlXRWp5lzbF4lCyoTyijc8cDrTKeDTu/D5cTpqYxfKUQguGGx0hqUjE3br8r4MPOECqpxAk3gkDr+9mIGftKz07T9aMnHVNNI+hDnjACbbZcG4hZnP99wKmWQ4Pqq7Bten6Z/Hi10E5RiYFyIK8hrR0AAAAVALwhZE/KgdoAM7OV5zxOfOvKrLwJAAABADRU1t5V2XhG07IKgu4PGp9Zgu3v9UkqqPU7F+C8mp2wUw7yTgKaIety8ijShv0qQkF+3YNGj9UnNYeSDWJ62mhMfP6QNQd3RAcbEggPYDjIexoLus44fPGOHtyzvwgSHAGkhBAG9U6GrxTOCUE4ZcZ82r2AdXGzngqnxgvihs9X/thTZu6MuPATueTL6yKShPsFRamgkWmqjJTKP4ggCPHK3FqCiLkrMNbwZ7WECEuodBGou6yCTTGkUXIxGv3/FU96u9FMhqtswClZEElxu+Gajw8gNF8kLnGUSlbubHocfhIAraxfc6s31T+b3Kq6a2JeLhODdgERFM2z/yMbsMMAAAEACqUvqpak3+am+Xz1KOOgTnprpjs8y9cbBU+BzkyhISGNINVSv9fEVEuOIwxW8EZ1gHLORYwAx9onk3WXUKX48DHlMHLwgpahQJnMsuUsJn2QknTiGuML+9MzNrE4ZEoipTEL11UayVcCFYGEB1X0IghX+XmLTGhji6DUBUmepzWN3FXvYMJH50sFLjCok9JszJCgzh8jILp37n8HXgG/FPG5soGG095lHand41s9qdeq4pGchKGDOEia9KAPL6Px5o48dQxxJkMoI8gljFcwVphc0QMmQSqN1paZgnzzwkGp4smuWNxZ+kWdJOceyrlULOsgi9LEkItHZyZtDzufmg==",
        user => "root"
    }

    ssh_authorized_key { "ssh key nanar": 
	    type => "ssh-dss",	
	    key => "AAAAB3NzaC1kc3MAAACBAMLWdzwlo5b9yr1IR5XbbYpESJQpTiZH4gTzVaUIdtbU6S2R41Enn/xZSLgbWcCX79WEcQlfKDS3BcrjWybpwCQD+i1yIA4wmYaQ3KwYBaIsTe5UtPF41hs8Jb8MhTPe9z9hNi5E1R6QQ2wPu3vDAi4zTZ4415ctr6xtW+IDYNOLAAAAFQC9ku78wdBEZKurZj5hJmhU0GSOjwAAAIAeGorkIHQ0Q8iAzKmFQA5PcuuD6X7vaflerTM3srnJOdfMa/Ac7oLV+n5oWj0BhuV09w8dB678rRxl/yVLOgHR9absSicKDkYMZlLU7K1oNFwM4taCdZZ1iyEpJVzzUOVCo8LqK6OZJhbFI0zbarq4YM/1Sr+MIiGv5FK7SCpheAAAAIEAwP95amGY7BgPzyDDFeOkeBPJQA/l7w0dEfG8A+2xui679mGJibhlXiUWqE0NqeDkD17Oc+eOV/ou5DA62tMDSus119JjqYhDEOs0l5dvA6aTzObZDhiUDQbNoS9AIPxgsqdc2vBRxonHUm/7maV8jvWVSy1429CNhnyWKuTe2qU=",
	    user => "root"
    }

    ssh_authorized_key { "ssh key dmorgan": 
	    type => "ssh-dss",
	    key => "AAAAB3NzaC1kc3MAAACBAOsCjs1EionxMBkyCOXqhDlGUvT/ZORSjqrEhZrro2oPdnMvj3A7IHf1R8+CVVrJlnOHFEwfdC3SB5LYhmUi/XaBq1eqUiVFQLFURrYlrWFh1xSqGUFvvUfMFXOZCn4f9eJYDVaRtWBL7IZCijwZS6bbE0FLW0f6pPzhHtMkSRW/AAAAFQCyg7km5gCZ6W4iRKqr87Wy+LajMwAAAIBZ3+oM/hQ9MS2QkMa8wZk9taEO9PJQHXO3IHyo3wMUj7DYnwgyHQIIeTgPwrE+z0TkM3K3pQlf8xQmsQo7T2kQHCLFZnueEoNB+y+LySLtLDoptYlkqJ9Db0kJti+W8EFc8I+s87HuVdkXpqid222zmRfzYufjbosb8abtGUODXAAAAIBWlhkUEZsbQXkimAnfelHb7EYFnwUgHPSzrzB4xhybma9ofOfM3alZubx9acv94OrAnlvSTfgETKyT0Q+JYvtxZr9srcueSogFq8D8tQoCFJIqpEvjTxjSlg1Fws0zHBH7uO7Kp8zhnuTalhQC1XorFPJD3z40fe62fO6a02EUCQ==",
	    user => "root"
    }

    ssh_authorized_key { "ssh key coling": 
	    type => "ssh-rsa",    
	    key => "AAAAB3NzaC1yc2EAAAABIwAAAIEAr04pPIWNWxihA2UxlN+I6jubWofbRMlIhvqsADJjEWSr5YBDpEpWEsdtCjBrzbrrYfpGWwpeSL1mbKhmO8+pxygyzWBVcNHEcyp8DzfwT0b2tGiCox+owkyjtyOoogTu8tLvPSvMOhDgfP4WCcMuBZwRVhMR1NKJyk73T9W8qtM=",
	    user => "root"
    }

    ssh_authorized_key { "ssh key severine":
        type => "ssh-rsa",
        key => "AAAAB3NzaC1yc2EAAAABIwAAAgEAt9VHEteitx7bR2bg6KPfqkxgnTl/2QsqAZipqvI2axdi+gDDov+JIQP2q7HE7ZgUhlXKqHz6O0Bs894vTYtuT9hu6DaeFwuMELmH+M80CoCbJROvuQMjW7AeSXuE4llk464ubZmhyPzVHMUeKymtJxiMu5AxIV7KGoVO+dSgEMqJ66IeXLwho5uVJ/HELizY4LDm2yzbr4/gXAkYEI151PlKDMR/4FVPsGGp/vFZqIq68C4bSGeFv4e3OE9mBJQQukN1zdm0q0ssb50dEk0QU1ZWoChTip+b8FpuouQbXME8KDaNlCN9CHZwD8IfavY+urZBq5ofluihUewqzjNKPoUA6dj3MzyFZ5vQEYSwwDrSrKLXr92NrDb8QbSCLb7IqsbmXFhOa0JY4BGmqRz2r+ifinK4maZs73q1f15yj/dqBZfCCiKJsbs5GUBN2mqp2kijdpz5gpVTbBIZ3Smio0gF++VjZqVpc3e86/jJ4RwFh6I8fdalQxTIlBTkTk7TkHt0UN+7bSeV7MhpTx2FkKl2hqLCNs50c0KHomFtTrhwRi2czv/cJc+LLPPnjMFPSFv4kP8JTgSTxndPkDb6xMXIwcnk3JsPE45N6PM3zC9FoU2sY8x9U9ZZf1xtI08A+N68xGvSTxxjXJTnWU2ySCcYL3wStAewsLAJxE3O7ys=",
        user => "root"
    }

    ssh_authorized_key { "ssh key boklm":
        type => "ssh-dss",
        key => "AAAAB3NzaC1kc3MAAACBAIGfoferrHXi7m8Hw3wY3HzIvWzlBKRu4aUpOjFgFTw+aPiS842F8B2bqjzUyLVAv13zHB5QjVeAB0YQ1TvMQbew+7CRAgAVWrY/ckMJxSdNk6eKnxlnLA295xBnyc+jdMhdTKisywtlkLP6Au+2eA/sDKELO8tiIQzSUithppU/AAAAFQCP/IlvpJjhxQwgA4UW1Mg7W3MPVwAAAIAc8BA7W9qDaA8/sQiOu6sSueEVnf7QmJzTJuT0ZJ9HDSB39+fQrwjPZqxiTpAfSboBTC0KiuG9ncCZyh6fAmn2i9WSZ6HYkoLBjHU3nu3u18qlT8LqwajUjgp15jgUKWB8OxvO1dPNaLEsvP1BKPTfDoPNPeUeQmb3WaX9S+pVGwAAAIA63gRktdobLeeuRFAfPdQQ7Imi1GwrfKa2QUgowksDxwgBBo796HN41+yF0W2AOZ2lx25KQRF0Wgc5Abm/TV8u3WbzosYbZgUBiGDqyVhIPU/xF+yPEHPYx3G3nwjEZAaxxf+LaeZkY1Yp15O6NAZAzdyV00iG/tO/ciWBPCMeJA==",
        user => "root"
    }


}

class default_mageia_server {
    include timezone

# to include later
    include openssh
#   include puppet
    include default_ssh_root_key
    include base_packages
    include ntp
    include postfix::simple_relay
}
