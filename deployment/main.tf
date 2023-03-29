locals {
  ctf = "cluster_challenges_cluster"
}

module "setup" {
  source = "./cluster_setup/"
  name   = local.ctf
}

module "ecr-blockchain-csgo" {
  source   = "./challenge_repositories"
  ecr_name = "challenge/blockchain/csgo_but_decentralised"
}

module "cluster-blockchain_csgo" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-blockchain-csgo.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "blockchain-csgo"
  ports          = [8545, 31337]
  desired_count  = 2
  subnet         = "10.0.11.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    },
    {
      name  = "PORT"
      value = "31337"
    },
    {
      name  = "HTTP_PORT"
      value = "8545"
    },
    {
      name  = "SHARED_SECRET"
      value = random_string.csgo_secret.result
    },
    {
      name  = "ETH_RPC_URL"
      value = "https://rpc.flashbots.net"
    },
    {
      name  = "FLAG"
      value = "UMASS{5h00t_t0_w1n_@mher5t}"
    },
    {
      name  = "PUBLIC_IP"
      value = "csgo_but_decentralised.blockchain.ctf.umasscybersec.org"
    },
  ]
  container_ports = [
    {
      containerPort = 31337
      hostPort      = 31337
    },
    {
      containerPort = 8545
      hostPort      = 8545
    }
  ]
}

module "ecr-crypto-wrath" {
  source   = "./challenge_repositories"
  ecr_name = "challenge/crypto/wrath"
}

module "cluster-crypto-wrath-fast" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-crypto-wrath.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "crypto-wrath"
  ports          = [9953]
  desired_count  = 2
  subnet         = "10.0.14.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 9953
      hostPort      = 9953
    }
  ]
}

module "ecr-crypto-wrath-fast" {
  source   = "./challenge_repositories"
  ecr_name = "challenge/crypto/wrath-fast"
}

module "cluster-crypto-wrath" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-crypto-wrath-fast.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "crypto-wrath-fast"
  ports          = [9953]
  cpu            = "2048"
  memory         = "4096"
  desired_count  = 2
  subnet         = "10.0.15.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 9953
      hostPort      = 9953
    }
  ]
}

resource "random_string" "csgo_secret" {
  length = 6
}


module "ecr-misc-blackjack" {
  source   = "./challenge_repositories"
  ecr_name = "challenge/misc/blackjack"
}

module "cluster-misc_blackjack" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-misc-blackjack.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "misc-blackjack"
  ports          = [2207]
  desired_count  = 2
  subnet         = "10.0.1.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 2207
      hostPort      = 2207
    }
  ]
}

module "ecr-misc-jeopardyv3" {
  source   = "./challenge_repositories"
  ecr_name = "challenge/misc/jeopardyv3"
}

module "cluster-misc_jeopardyv3" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-misc-jeopardyv3.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "misc-jeopardyv3"
  ports          = [1116]
  desired_count  = 2
  subnet         = "10.0.2.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 1116
      hostPort      = 1116
    }
  ]
}


module "ecr-pwn-babysc" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/pwn/babysc"
}

module "cluster-pwn-babysc" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-pwn-babysc.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  cpu            = "1024"
  memory         = "2048"
  name           = "pwn-babysc"
  ports          = [3000]
  desired_count  = 1
  subnet         = "10.0.10.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 3000
      hostPort      = 3000
    }
  ]
}

module "ecr-pwn-last" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/pwn/last"
}

module "cluster-pwn-last" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-pwn-last.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  cpu            = "256"
  memory         = "512"
  name           = "pwn-last"
  ports          = [7293]
  desired_count  = 2
  subnet         = "10.0.23.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 7293
      hostPort      = 7293
    }
  ]
}

# Web JSON
module "ecr-web-deepfry" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/deepfry"
}

module "cluster-web-deepfry" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-deepfry.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "web-deepfry"
  ports          = [3000]
  desired_count  = 2
  subnet         = "10.0.30.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    }
  ]
  container_ports = [
    {
      containerPort = 3000
      hostPort      = 3000
    }
  ]
}

# Web JSON
module "ecr-web-json_app" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/json_app"
}

module "cache-web-json_app" {
  source  = "./elasticache/"
  name    = "web-json-cache"
  subnet  = "10.0.3.0/24"
  subnet1 = "10.0.255.0/24"
  subnet2 = "10.0.254.0/24"
  vpc_id  = module.setup.vpc_id
}

module "cluster-web-json_app" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-json_app.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "web-json-app"
  ports          = [3000]
  desired_count  = 2
  subnet         = "10.0.3.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    },
    {
      name  = "SERVER_PORT"
      value = "3000"
    },
    {
      name  = "ADMIN_ACCOUNT"
      value = "iPr0m1s3i4mn0ts1lv3r1"
    },
    {
      name  = "FLAG"
      value = "UMASS{M4YB3_JS_$h0uld_b3_0FF_BruH_XDDDDDD489253}"
    },
    {
      name  = "REDIS_URL"
      value = module.cache-web-json_app.cache_url
    }
  ]
  container_ports = [
    {
      containerPort = 3000
      hostPort      = 3000
    }
  ]
}

module "ecr-web-json_bot" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/json_bot"
}

module "cluster-web-json_bot" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-json_bot.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "web-json-bot"
  ports          = [9000]
  desired_count  = 2
  subnet         = "10.0.4.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "1"
    },
    {
      name  = "DOMAIN"
      value = "app-json.web.ctf.umasscybersec.org"
    },
    {
      name  = "ADMIN_ACCOUNT"
      value = "iPr0m1s3i4mn0ts1lv3r1"
    }
  ]
  container_ports = [
    {
      containerPort = 9000
      hostPort      = 9000
    }
  ]
}

# Web JSON V2
module "ecr-web-json2_app" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/json2_app"
}

module "cache-web-json2_app" {
  source  = "./elasticache/"
  name    = "web-json2-cache"
  subnet  = "10.0.33.0/24"
  subnet1 = "10.0.240.0/24"
  subnet2 = "10.0.241.0/24"
  vpc_id  = module.setup.vpc_id
}

module "cluster-web-json2_app" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-json2_app.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "web-json2-app"
  ports          = [3000]
  desired_count  = 2
  subnet         = "10.0.33.0/24"
  container_env = [
    {
      name  = "Revision"
      value = "1"
    },
    {
      name  = "SERVER_PORT"
      value = "3000"
    },
    {
      name  = "ADMIN_ACCOUNT"
      value = "iPr0m1s3i4mn0ts1lv3r1"
    },
    {
      name  = "FLAG"
      value = "UMASS{W41T_1_Th0ught_1_b4nn3d_th41_lm40}"
    },
    {
      name  = "REDIS_URL"
      value = module.cache-web-json2_app.cache_url
    }
  ]
  container_ports = [
    {
      containerPort = 3000
      hostPort      = 3000
    }
  ]
}

module "ecr-web-json2_bot" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/json2_bot"
}

module "cluster-web-json2_bot" {
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-json2_bot.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  name           = "web-json2-bot"
  ports          = [9000]
  desired_count  = 2
  subnet         = "10.0.4.0/24"
  container_env = [
    {
      name  = "Revision"
      value = "1"
    },
    {
      name  = "DOMAIN"
      value = "app-json2.web.ctf.umasscybersec.org"
    },
    {
      name  = "ADMIN_ACCOUNT"
      value = "iPr0m1s3i4mn0ts1lv3r1"
    }
  ]
  container_ports = [
    {
      containerPort = 9000
      hostPort      = 9000
    }
  ]
}

# Web umassdining2
module "ecr-web-umassdining2" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/umassdining2"
}

module "db-web-umassdining2" {
  source         = "./rds/"
  name           = "umassdining2"
  subnet         = "10.0.5.0/24"
  subnet1        = "10.0.253.0/24"
  subnet2        = "10.0.252.0/24"
  route_table_id = module.setup.route_table_id
  vpc_id         = module.setup.vpc_id
  password       = "umassdiningisepic69420"
  username       = "root"
}

# Manually setup instead
# mysql -u root --host=${module.db-web-umassdining2.db_host} -p umassdining --password=umassdiningisepic69420 < ${data.local_file.setup-file-web-umassdining2.content}
#data "local_file" "setup-file-web-umassdining2" {
#  filename = "../web/umassdining2/src/init/init.sql"
#}
#
#resource "null_resource" "setup-web-umassdining2" {
#  depends_on = [module.db-web-umassdining2, data.local_file.setup-file-web-umassdining2]
#  provisioner "local-exec" {
#    command = "mysql -u root --host=${module.db-web-umassdining2.db_host} -p umassdining --password=umassdiningisepic69420 < ${data.local_file.setup-file-web-umassdining2.content}"
#  }
#}

module "cluster-web-umassdining2" {
  #  depends_on = [null_resource.setup-web-umassdining2]
  depends_on     = [module.db-web-umassdining2]
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-umassdining2.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  cpu            = "1024"
  memory         = "2048"
  auto_scaling   = false
  name           = "umassdining2"
  ports          = [6942]
  desired_count  = 1
  subnet         = "10.0.5.0/24"
  container_env  = [
    {
      name  = "Revision"
      value = "2"
    },
    {
      name  = "SQL_HOST"
      value = module.db-web-umassdining2.db_host
    },
    {
      name  = "MYSQL_ROOT_PASSWORD"
      value = "umassdiningisepic69420"
    },
    {
      name  = "SERVER_PORT"
      value = "6942"
    },
    {
      name  = "JWT_SECRET"
      value = "aSm0K3aD4Yk33P$tH3d0ct0r4w4y"
    },
    {
      name  = "FLAG"
      value = "UMASS{F0rg0t_T0_R3TuRn_4nd_l0st_mY_FL4g}"
    }
  ]
  container_ports = [
    {
      containerPort = 6942
      hostPort      = 6942
    }
  ]
}

# Web secureblocks
module "ecr-web-secureblocks" {
  source   = "./challenge_repositories/"
  ecr_name = "challenge/web/secureblocks"
}

module "db-web-secureblocks" {
  source         = "./rds/"
  name           = "secureblocks"
  subnet         = "10.0.27.0/24"
  subnet1        = "10.0.251.0/24"
  subnet2        = "10.0.250.0/24"
  route_table_id = module.setup.route_table_id
  vpc_id         = module.setup.vpc_id
  password       = "umassdiningisepic69420"
  username       = "root"
}

# Manually setup db
# mysql -u root --host=${module.db-web-umassdining2.db_host} -p umassdining --password=umassdiningisepic69420 < ${data.local_file.setup-file-web-umassdining2.content}

module "cluster-web-secureblocks" {
  depends_on     = [module.db-web-secureblocks]
  source         = "./cluster_challenge"
  ctf            = local.ctf
  ecr_repo       = module.ecr-web-secureblocks.ecr
  vpc_id         = module.setup.vpc_id
  route_table_id = module.setup.route_table_id
  cpu            = "512"
  memory         = "1024"
  auto_scaling   = false
  name           = "web-secureblocks"
  ports          = [80]
  desired_count  = 1
  subnet         = "10.0.27.0/24"
  container_env = [
    {
      name  = "Revision"
      value = "1"
    },
    {
      name = "SERVER_PORT"
      value = 3000
    },
    {
      name  = "SQL_HOST"
      value = module.db-web-secureblocks.db_host
    },
    {
      name  = "MYSQL_ROOT_PASSWORD"
      value = "umassdiningisepic69420"
    },
    {
      name  = "JWT_SECRET"
      value = "n1c3l1ttl3s3cr3t"
    },
    {
      name  = "FLAG"
      value = "UMASS{M1N3_D14M0ND$_L1K3_4_B0SS_111222333}"
    },
    {
      name = "DEBUG_HEADER"
      value = "Z4_B3ST_1N_Z4_W3ST_BRUH"
    }
  ]
  container_ports = [
    {
      containerPort = 80
      hostPort      = 80
    }
  ]
}