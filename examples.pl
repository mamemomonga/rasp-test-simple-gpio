#!/usr/bin/env perl
use utf8;
use feature 'say';
use strict;
use warnings;

binmode(STDOUT,':utf8');
binmode(STDERR,':utf8');
binmode(STDIN, ':utf8');

use FindBin;
use lib "$FindBin::Bin/lib";

use Device::BCM2835::SimpleGPIO;

# 交互に点滅するLEDの速度をスイッチで変える
sub example1 {

	# LEDの設定
	my %leds=(
		# gpio => はピン番号ではなく、BCM2835のGPIO番号を指定する。
		# function => 'output' でピンを出力に設定
		'led1'  => Device::BCM2835::SimpleGPIO->new( gpio=>16, function=>'output' ),
		'led2'  => Device::BCM2835::SimpleGPIO->new( gpio=>20, function=>'output' ),
		'led3'  => Device::BCM2835::SimpleGPIO->new( gpio=>21, function=>'output' ),
	);

	# スイッチの設定
	my %switches=(
		# function => 'output' でピンを入力に設定
		'tact1' => Device::BCM2835::SimpleGPIO->new( gpio=>19, function=>'input'  ),
		'tact2' => Device::BCM2835::SimpleGPIO->new( gpio=>26, function=>'input'  ),
	);

	# 点滅の順番
	my @blink=(
		# 1:点灯 / 0:消灯
		{ led1=>1, led2=>0, led3=>0 },
		{ led1=>0, led2=>1, led3=>0 },
		{ led1=>0, led2=>0, led3=>1 },
		{ led1=>1, led2=>1, led3=>1 }
	);

	# タクトスイッチが押されている間に増える数字
	my %switches_counter=(
		'tact1' => 0,
		'tact2' => 0
	);

	# LED処理待ち時間初期設定( delayを繰り返す回数 )
	my $wait=10;

	# LED処理待ち時間のカウンタ
	my $wait_count=0;

	# 現在の@blinkの位置
	my $led_position=0;

	# 無限ループ
	while(1) {

		# タクトスイッチの状態を確認
		foreach my $name(qw( tact1 tact2 )) {
			# 押されていたら数字を増やす
			$switches_counter{$name}++ if($switches{$name}->read == 0);

			# 数字が10を越えたらリセットして、LED処理待ち時間を増減する
			if( $switches_counter{$name} > 10 ){
				$switches_counter{$name}=0;
				$wait++ if($name eq 'tact1');
				$wait-- if($name eq 'tact2');
				$wait=60 if($wait > 60);
				$wait=0  if($wait < 0);
				say "wait: $wait";
			}
		}

		# LED処理待ち時間が規定値に達したら
		if($wait <= $wait_count) {
			# LEDを動かす
			while(my($name,$level)=each %{$blink[$led_position]}) {
				$leds{$name}->write($level);
			}
			$led_position++;
			$led_position=0 if ($led_position >=$#blink);
			$wait_count=0;
		}
		# 10ミリ秒待つ
		$switches{tact1}->delay(10);
		$wait_count++;
	}
}

# example を実行
example1;

