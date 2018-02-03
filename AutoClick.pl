use strict;
use warnings;
use WWW::Selenium;
use autodie;
use Try::Tiny;

$|=1;

my $savedata;
open(my $fh, "<", "savedata.txt") or die $!;
while ( defined(my $l = <$fh>) ) {
    chomp $l;
    if ( $l ne '' ) {
        $savedata = $l;
    }
}
close $fh;

my $sel = WWW::Selenium->new(
    host => "localhost",
    port => 4444,
    browser => "*firefox",
    browser_url => "http://orteil.dashnet.org/",
);

$sel->start;
$sel->open("/cookieclicker/");
$sel->get_eval("window.localStorage.setItem('CookieClickerGame', '$savedata')");
while (1) {
    next if ( !$sel->get_eval("window.Game.ready") );
    last;
}

my $locator_golden_cookie = 'xpath=//div[@class="shimmer"]';
my $locator_big_cookie = "id=bigCookie";
my $locator_export = '//a[text()="Export save"]';
my $tm = time();

while ( 1 ) {
    try {
        if ( &click($locator_golden_cookie, "goldenCookie") + &click($locator_golden_cookie, "goldenCookie") ) {
            if ($sel->get_eval("window.Game.hasBuff('Cookie storm')")) {
                my $err = '';
                for (1 .. 10) {
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie); $sel->click($locator_golden_cookie);
                    print "\nclick cookie storming";
                }
            }

            if ( $tm + 600 < time() ) {
                $savedata = $sel->get_eval("window.localStorage.getItem('CookieClickerGame')");
                open my $fh, ">>", "savedata.txt" or die $!;
                print $fh "$savedata\n";
                close $fh;
                $tm = time();
                my ($sec, $min, $hour) = localtime($tm);
                printf("\nsaved(%02d:%02d:%02d)", $hour, $min, $sec);
            }
        }
    } catch {
        print "ERROR(while): $_";
    };

    &buy_upgrade();
    &buy_product();

    if ( $sel->get_eval("window.Game.elderWrath") ) {
        &explode_wrinklers();
    }
    print ".";
}

sub buy_upgrade {
    my $locator = '//div[@id="upgrades"]/div[@class="crate upgrade enabled"][1]';
    &click($locator, "upgrade");
}

sub buy_product {
    my $locator = '//div[@id="products"]/div[@class="product unlocked enabled"][last()]';
    &click($locator, "product");
}

sub explode_wrinklers {
    $sel->get_eval("window.Game.SaveWrinklers().number < window.Game.getWrinklersMax() || window.Game.CollectWrinklers()");
}

sub click {
    my $locator = shift;
    my $target_name = shift;
    my $rtn;

    try {
        $sel->click($locator);
        print "\nclick $target_name" if ( $target_name );
        $rtn = 1;
    } catch {
        $rtn = 0;
    };
    return $rtn;
}
