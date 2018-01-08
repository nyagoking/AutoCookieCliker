use strict;
use warnings;
use WWW::Selenium;
use autodie;
use Try::Tiny;

$|=1;

my $sel = WWW::Selenium->new(
    host => "localhost",
    port => 4444,
    browser => "*firefox",
    browser_url => "http://orteil.dashnet.org/",
);

$sel->start;
$sel->open("/cookieclicker/");
my $savedata = '';
while (1) {
    next if ( !$sel->get_eval("window.Game.ready") );

    my $locator_import = '//a[text()="Import save"]';
    &to_menu_and_click($locator_import, "import");
    last;
}

my $locator_textarea_prompt = "id=textareaPrompt";
my $locator_prompt_option0 = "id=promptOption0";

while ( 1 ) {
    next if ( !&is_enabled($locator_textarea_prompt) );
    next if ( !$sel->is_visible($locator_textarea_prompt) );
    next if ( !$sel->is_visible($locator_prompt_option0) );

    my $text = &get_text($locator_textarea_prompt);
    my $btnText = &get_text($locator_prompt_option0);

    next if ( $text ne '' );
    next if ( $btnText ne 'Load' );

    open(my $fh, "<", "savedata.txt") or die $!;
    while ( defined(my $l = <$fh>) ) {
        chomp $l;
        if ( $l ne '' ) {
            $savedata = $l;
        }
    }
    close $fh;

    $sel->type($locator_textarea_prompt, $savedata);
    &click($locator_prompt_option0);
    sleep 2;
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

sub to_menu_and_click {
    my $locator = shift;
    my $target_name = shift;
    my $locator_menu_button = '//div[@id="prefsButton"]';

    while (!&is_enabled($locator)) {
        &click($locator_menu_button, "menu");
    }
    &click($locator, $target_name);
}

sub buy_upgrade {
    my $locator = '//div[@id="upgrades"]/div[@class="crate upgrade enabled"][1]';
    &click($locator, "upgrade");
}

sub buy_product {
    my $locator = '//div[@id="products"]/div[@class="product unlocked enabled"][last()]';
    &click($locator, "product");
}

sub is_enabled {
    my $locator = shift;
    return $sel->is_element_present($locator);
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

sub get_text {
    my $locator = shift;
    my $text;

    while ( !defined($text) ) {
        try {
            $text = $sel->get_text($locator);
        } catch {
            print "\nERROR(get_text): $_";
        };
    }

    return $text;
}
