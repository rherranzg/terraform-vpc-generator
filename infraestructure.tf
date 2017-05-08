resource "aws_vpc" "my_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${var.tags}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  count                   = "${length(var.public_subnets)}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.azs, count.index)}"
  tags                    = "${var.tags}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  count             = "${length(var.private_subnets) * lookup(map(var.private_infra, 1), "true", 0)}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  tags              = "${var.tags}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags   = "${var.tags}"
}

resource "aws_route_table" "public" {
  vpc_id  = "${aws_vpc.my_vpc.id}"
  tags    = "${var.tags}"
}

resource "aws_route_table" "private" {
  vpc_id  = "${aws_vpc.my_vpc.id}"
  count   = "${length(var.private_subnets) * lookup(map(var.private_infra, 1), "true", 0)}"
  tags    = "${var.tags}"
}

resource "aws_eip" "nateip" {
  vpc   = true
  count = "${length(var.private_subnets) * lookup(map(var.private_infra, 1), "true", 0)}"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  count         = "${length(var.private_subnets) * lookup(map(var.private_infra, 1), "true", 0)}"

  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                  = "${length(var.private_subnets) * lookup(map(var.private_infra, 1), "true", 0)}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets) * lookup(map(var.private_infra, 1), "true", 0)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
