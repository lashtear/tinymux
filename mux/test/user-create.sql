create user 'muxtest'@'localhost' identified by 'muxtest';
create database muxtest;
grant all privileges on muxtest.* to 'muxtest'@'localhost';
