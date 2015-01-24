package Device::BCM2835::SimpleGPIO;
use strict;
use warnings;
# https://github.com/mamemomonga/rasp-test-simple-gpio

# 参考:
# http://search.cpan.org/~mikem/Device-BCM2835-1.1/lib/Device/BCM2835.pm
# /usr/local/include/bcm2835.h

use Device::BCM2835;
Device::BCM2835::init();

# Device::BCM2835::set_debug(1);

sub new {
	my($class,%opts)=(shift,@_);
	my $self={ gpio => $opts{gpio} };
	bless($self,$class);
	$self->function($opts{function}) if($opts{function});
	return $self;
}

sub function {
	my ($self,$func)=@_;
	Device::BCM2835::gpio_fsel($self->{gpio},{
		'input'	=> Device::BCM2835::BCM2835_GPIO_FSEL_INPT,
		'output'=> Device::BCM2835::BCM2835_GPIO_FSEL_OUTP,
 		'alt0'  => Device::BCM2835::BCM2835_GPIO_FSEL_ALT0,
 		'alt1'  => Device::BCM2835::BCM2835_GPIO_FSEL_ALT1,
 		'alt2'  => Device::BCM2835::BCM2835_GPIO_FSEL_ALT2,
 		'alt3'  => Device::BCM2835::BCM2835_GPIO_FSEL_ALT3,
 		'alt4'  => Device::BCM2835::BCM2835_GPIO_FSEL_ALT4,
 		'alt5'  => Device::BCM2835::BCM2835_GPIO_FSEL_ALT5,
 		'mask'  => Device::BCM2835::BCM2835_GPIO_FSEL_MASK,
	}->{$func});
	return $self;
}
sub write {
	my ($self,$val)=@_;
	Device::BCM2835::gpio_write( $self->{gpio}, $val );
	return $self;
}

sub read {
	my ($self)=@_;
	return Device::BCM2835::gpio_lev( $self->{gpio} );
}

sub delay {
	my ($self,$wait)=@_;
	Device::BCM2835::delay($wait);
	return $self;
}

1;

