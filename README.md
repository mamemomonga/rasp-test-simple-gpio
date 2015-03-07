# Raspberry Pi + Perl(Device::BCM2835)でGPIO

Raspberry Pi + Perl(Device::BCM2835) でGPIOからLEDの点滅とスイッチ操作をやってみる。

## サンプルの実行方法
まず回路を組みます。Device::BCM2835を入れます。実行します。
Device::BCM2835のインストールには、[BCM2835 C ライブラリ](http://www.airspayce.com/mikem/bcm2835/)が必要です。

	$ sudo aptitude install carton
	$ carton
	$ sudo carton exec ./examples.pl

