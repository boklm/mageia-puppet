class common::default_ssh_root_key {
    Ssh_authorized_key {
        user => 'root'
    }

    ssh_authorized_key { 'ssh_key_misc':
        type => 'ssh-rsa',
        key  => 'AAAAB3NzaC1yc2EAAAABIwAAAgEA4fpjTvcL09Yzv7iV40TPjiXGHOOS5MldSh5ezSk7AMLVjAAloiidl8O3xwlxwUnjUx5zv1+RlbV76sdiSD32lBht72OZPg0UqQIB8nHeVJBdJ8YpnQ3LynNPPYJ65dvdr0uE2KRlN/1emi2N+O+f2apwc1YiL8nySEK/zLvCKO5xj16bIVuGFilDdp75X/t3C/PDsZU+CUyWL5Ly3T2+ljGc+nEAK9P0PNnvl9bRK9dqu457xjca8nXwWVI1fd6Jnt1jISFdQXy6/+9326Z6aAxvWKCrCvmdg+tAUN3fEj0WXZEPZQ1Ot0tBxKYl+xhV1Jv/ILLbInT0JZkSEKNBnJn4G7O4v+syoMqA7myHre73oGn/ocRWGJskIM33aXrJkZkJ4LkF1GLJPFI4y7bzj024sPAVvBwDrV7inwsOy0DSQ5tCbfX25TTXbK+WMXzz0pBbSi6mPgjtzlSYsLZrTa7ARYhggDG2miuOAFrup8vP7/aH2yZ+hZuF70FsMh4lf/eXDGwfypyfYrjfVSkFfY0ZU294ouTBn3HtHmgFu82vOMvLNtI9UyERluCBpLBXOT8xgM97aWFeUJEKrVxkGIiNwVNylMEYp8r16njv810NdTLA3jZu9CLueVvME6GLsGve5idtGmaYuGYNRnSRx3PQuJZl1Nj7uQHsgAaWdiM=',
    }

    ssh_authorized_key { 'ssh_key_dams':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAACBAP7Dz4U90iWjb8SXVpMsC/snU0Albjsi5rSVFdK5IqG0jcQ3K5F/X8ufUN+yOHxpUKeE6FAPlvDxIQD8hHv53yAoObM4J4h2SVd7xXpIDTXhdQ9kMYbgIQzyI/2jptF77dxlwiH9TirmmpUSb680z55IkVutwSVJUOZCOWFXfa35AAAAFQDqYF7tWvnzM/zeSFsFZ9hqKCj47QAAAIBdmaPCyf4iU9xGUSWi1p7Y6OlUcfu2KgpETy8WdOmZ4lB3MXdGIoK5/LLeLeeGomAVwJMw3twOOzj4e1Hz16WM+fWsMVFnZftLFo9L2LvSQElIEznjIxqfmIsc2Id2c0gI+kEnigOWbBJ7h0O09uT7/eNBysqgseCMErzedy5ZnAAAAIAGrjfWjVtJQa888Sl8KjKM9MXXvgnyCDCBP9i4pncsFOWEWGMWPY0Z9CD0OZYDdvWLnFkrnoMaIvWQU7pb4/u/Tz9Dsm65eQzUaLSGFzROAX6OB47L7spMS4xd6SF+ASawy/aYiHf241zumJLvPkUpXceBv2s7QOp2g6S6qCtypA==',
    }

    ssh_authorized_key { 'ssh_key_blino':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAAEBAIuMeFTbzLwcxlKfqSUDmrh2lFVOZyjotQsUm4EGZIh8killmHCBmB8uYvh3ncwvcC8ZwfRU9O8jX6asKJckFIZ37cdHaTQR7fh5ozG4ab652dPND2yKCg1LCwf2x0/Ef1VtyF7jpTG/L9ZaGpeXQ8rykoH4rRnfSdYF0xT7ua9F/J/9ss5FtzQYbQLFMzV3SlXRWp5lzbF4lCyoTyijc8cDrTKeDTu/D5cTpqYxfKUQguGGx0hqUjE3br8r4MPOECqpxAk3gkDr+9mIGftKz07T9aMnHVNNI+hDnjACbbZcG4hZnP99wKmWQ4Pqq7Bten6Z/Hi10E5RiYFyIK8hrR0AAAAVALwhZE/KgdoAM7OV5zxOfOvKrLwJAAABADRU1t5V2XhG07IKgu4PGp9Zgu3v9UkqqPU7F+C8mp2wUw7yTgKaIety8ijShv0qQkF+3YNGj9UnNYeSDWJ62mhMfP6QNQd3RAcbEggPYDjIexoLus44fPGOHtyzvwgSHAGkhBAG9U6GrxTOCUE4ZcZ82r2AdXGzngqnxgvihs9X/thTZu6MuPATueTL6yKShPsFRamgkWmqjJTKP4ggCPHK3FqCiLkrMNbwZ7WECEuodBGou6yCTTGkUXIxGv3/FU96u9FMhqtswClZEElxu+Gajw8gNF8kLnGUSlbubHocfhIAraxfc6s31T+b3Kq6a2JeLhODdgERFM2z/yMbsMMAAAEACqUvqpak3+am+Xz1KOOgTnprpjs8y9cbBU+BzkyhISGNINVSv9fEVEuOIwxW8EZ1gHLORYwAx9onk3WXUKX48DHlMHLwgpahQJnMsuUsJn2QknTiGuML+9MzNrE4ZEoipTEL11UayVcCFYGEB1X0IghX+XmLTGhji6DUBUmepzWN3FXvYMJH50sFLjCok9JszJCgzh8jILp37n8HXgG/FPG5soGG095lHand41s9qdeq4pGchKGDOEia9KAPL6Px5o48dQxxJkMoI8gljFcwVphc0QMmQSqN1paZgnzzwkGp4smuWNxZ+kWdJOceyrlULOsgi9LEkItHZyZtDzufmg==',
    }

    ssh_authorized_key { 'ssh_key_nanar':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAACBAMLWdzwlo5b9yr1IR5XbbYpESJQpTiZH4gTzVaUIdtbU6S2R41Enn/xZSLgbWcCX79WEcQlfKDS3BcrjWybpwCQD+i1yIA4wmYaQ3KwYBaIsTe5UtPF41hs8Jb8MhTPe9z9hNi5E1R6QQ2wPu3vDAi4zTZ4415ctr6xtW+IDYNOLAAAAFQC9ku78wdBEZKurZj5hJmhU0GSOjwAAAIAeGorkIHQ0Q8iAzKmFQA5PcuuD6X7vaflerTM3srnJOdfMa/Ac7oLV+n5oWj0BhuV09w8dB678rRxl/yVLOgHR9absSicKDkYMZlLU7K1oNFwM4taCdZZ1iyEpJVzzUOVCo8LqK6OZJhbFI0zbarq4YM/1Sr+MIiGv5FK7SCpheAAAAIEAwP95amGY7BgPzyDDFeOkeBPJQA/l7w0dEfG8A+2xui679mGJibhlXiUWqE0NqeDkD17Oc+eOV/ou5DA62tMDSus119JjqYhDEOs0l5dvA6aTzObZDhiUDQbNoS9AIPxgsqdc2vBRxonHUm/7maV8jvWVSy1429CNhnyWKuTe2qU=',
    }

    ssh_authorized_key { 'ssh_key_dmorgan':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAACBAOsCjs1EionxMBkyCOXqhDlGUvT/ZORSjqrEhZrro2oPdnMvj3A7IHf1R8+CVVrJlnOHFEwfdC3SB5LYhmUi/XaBq1eqUiVFQLFURrYlrWFh1xSqGUFvvUfMFXOZCn4f9eJYDVaRtWBL7IZCijwZS6bbE0FLW0f6pPzhHtMkSRW/AAAAFQCyg7km5gCZ6W4iRKqr87Wy+LajMwAAAIBZ3+oM/hQ9MS2QkMa8wZk9taEO9PJQHXO3IHyo3wMUj7DYnwgyHQIIeTgPwrE+z0TkM3K3pQlf8xQmsQo7T2kQHCLFZnueEoNB+y+LySLtLDoptYlkqJ9Db0kJti+W8EFc8I+s87HuVdkXpqid222zmRfzYufjbosb8abtGUODXAAAAIBWlhkUEZsbQXkimAnfelHb7EYFnwUgHPSzrzB4xhybma9ofOfM3alZubx9acv94OrAnlvSTfgETKyT0Q+JYvtxZr9srcueSogFq8D8tQoCFJIqpEvjTxjSlg1Fws0zHBH7uO7Kp8zhnuTalhQC1XorFPJD3z40fe62fO6a02EUCQ==',
    }

    ssh_authorized_key { 'ssh_key_coling':
        type => 'ssh-rsa',
        key  => 'AAAAB3NzaC1yc2EAAAABIwAAAIEAr04pPIWNWxihA2UxlN+I6jubWofbRMlIhvqsADJjEWSr5YBDpEpWEsdtCjBrzbrrYfpGWwpeSL1mbKhmO8+pxygyzWBVcNHEcyp8DzfwT0b2tGiCox+owkyjtyOoogTu8tLvPSvMOhDgfP4WCcMuBZwRVhMR1NKJyk73T9W8qtM=',
    }

    ssh_authorized_key { 'ssh_key_boklm':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAACBAIGfoferrHXi7m8Hw3wY3HzIvWzlBKRu4aUpOjFgFTw+aPiS842F8B2bqjzUyLVAv13zHB5QjVeAB0YQ1TvMQbew+7CRAgAVWrY/ckMJxSdNk6eKnxlnLA295xBnyc+jdMhdTKisywtlkLP6Au+2eA/sDKELO8tiIQzSUithppU/AAAAFQCP/IlvpJjhxQwgA4UW1Mg7W3MPVwAAAIAc8BA7W9qDaA8/sQiOu6sSueEVnf7QmJzTJuT0ZJ9HDSB39+fQrwjPZqxiTpAfSboBTC0KiuG9ncCZyh6fAmn2i9WSZ6HYkoLBjHU3nu3u18qlT8LqwajUjgp15jgUKWB8OxvO1dPNaLEsvP1BKPTfDoPNPeUeQmb3WaX9S+pVGwAAAIA63gRktdobLeeuRFAfPdQQ7Imi1GwrfKa2QUgowksDxwgBBo796HN41+yF0W2AOZ2lx25KQRF0Wgc5Abm/TV8u3WbzosYbZgUBiGDqyVhIPU/xF+yPEHPYx3G3nwjEZAaxxf+LaeZkY1Yp15O6NAZAzdyV00iG/tO/ciWBPCMeJA==',
    }

    ssh_authorized_key { 'ssh_key_buchan':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAACBALpYDQtkZcfXdOILynCGa7IAbW4+etmzpIMjw6BfvZOfLT6UPfDwajhDBMBNSbgigxkxxEdsa0/UMIE3Yrpr8YivhbL79sFw2N/FeWCs3Vk8JXNjBGA6itAIz9nwfh6qCDUj2t8LTdOQdYrSFOO7x2dFgeCwi21V27Ga2vqsvkUnAAAAFQD708pfON6Itq/5S+4kkNdNNDKWCwAAAIEAkRQeugul6KmOC0C2EmgVJvKK1qImlwHir08W1LTESnujmRIWLRst8sDoKjJpNevFuHGybPQ3palvM9qTQ84k3NMsJYJZSjSexsKydHJbD4ErKk8W6k+Xo7GAtH4nUcNskbnLHUpfvzm0jWs2yeHS0TCrljuTQwX1UsvGKJanzEoAAACBAIurf3TAfN2FKKIpKt5vyNv2ENBVcxAHN36VH8JP4uDUERg/T0OyLrIxW8px9naI6AQ1o+fPLquJ3Byn9A1RZsvWAQJI/J0oUit1KQM5FKBtXNBuFhIMSLPwbtp5pZ+m0DAFo6IcY1pl1TimGa20ajrToUhDh1NpE2ZK//8fw2i7',
    }

    ssh_authorized_key { 'ssh_key_tmb':
        type => 'ssh-dss',
        key  => 'AAAAB3NzaC1kc3MAAACBAMFaCUsen6ZYH8hsjGK0tlaguduw4YT2KD3TaDEK24ltKzvQ+NDiPRms1zPhTpRL0p0U5QVdIMxm/asAtuiMLMxdmU+Crry6s110mKKY2930ZEk6N4YJ4DbqSiYe2JBmpJVIEJ6Betgn7yZRR2mRM7j134PddAl8BGG+RUvzib7JAAAAFQDzu/G2R+6oe3vjIbbFpOTyR3PAbwAAAIEAmqXAGybY9CVgGChSztPEdvaZ1xOVGJtmxmlWvitWGpu8m5JBf57VhzdpT4Fsf4fiVZ7NWiwPm1DzqNX7xCH7IPLPK0jQSd937xG9Un584CguNB76aEQXv0Yl5VjOrC3DggIEfZ1KLV7GcpOukw0RerxKz99rYAThp6+qzBIrv38AAACBAKhXi7uNlajescWFjiCZ3fpnxdyGAgtKzvlz60mGKwwNyaQCVmPSmYeBI2tg1qk+0I5K6LZUxWkdhuE1UfvAbIrEdwyD8p53dPg1J9DpdQ1KqApeKqLxO02KJtfomuy3cRQXmdfOTovYN7zAu1NCp51uUNTzhIpDHx0MZ6bsWSFv',
    }

    ssh_authorized_key { 'ssh_key_pterjan':
        type => 'ssh-rsa',
        key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAspyZMl5zAkk5SL45zFvtJF7UhXTRb0bEaZ3nuCC1Ql5wM3GWuftqd5zLH88dCu7ZO/BVh213LZTq/UHb6lI7kWalygk53qtdEx2cywjWFOW23Rg6xybatCEZ2/ZrpGZoBGnu63otAp4h2Nnj/VkOio3pGwD8vavmZ4xPrcECPAwtMPJsYf44Ptu2JdXizi4iY8I0/HKitQ113I4NbDcAiMKbTXSbOfqC+ldcgW3+9xShx/kuMFTKeJOy4LI4GR6gykzkV6+vfnalp24x/SIEjuohBarCRQKo4megHqZOzdMYAHqq0QuNubXURNb0Mvz1sE7Y8AFIxwSfXdQGi5hcQQ==',
    }
}
