output "vpc_id" {
  #value = "${aws_vpc.my_vpc.id}"
  value = "${aws_vpc.my_vpc.id}"
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}
