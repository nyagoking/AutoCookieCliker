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

my $tm0 = time();

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
my $locator_golden_cookie = 'xpath=//div[@class="shimmer"]';
my $locator_big_cookie = "id=bigCookie";
my $locator_season_popup = "id=seasonPopup";
my $locator_export = '//a[text()="Export save"]';

while ( 1 ) {
    try {
        if ( &is_enable($locator_textarea_prompt) &&
                $sel->is_visible($locator_textarea_prompt) &&
                $sel->is_visible($locator_prompt_option0) ) {
            my $text = &get_text($locator_textarea_prompt);
            my $btnText = &get_text($locator_prompt_option0);

            if ( $btnText eq 'All done!' && $savedata ne $text ) {
                $savedata = $text;
                open my $fh, ">>", "savedata.txt" or die $!;
                print $fh "$savedata\n";
                close $fh;
                while ( !&click($locator_prompt_option0) ) {
                    next;
                }
            } elsif ( $btnText eq 'Load' && $text eq '' ) {
                open(my $fh, "<", "savedata.txt") or die $!;
                while ( defined(my $l = <$fh>) ) {
                    chomp $l;
                    if ( $l ne '' ) {
                        $savedata = $l;
                    }
                }
                close $fh;
                while ( 1 ) {
                    if ( $sel->is_visible("id=textareaPrompt") &&
                            $sel->is_visible($locator_prompt_option0) ) {
                        $sel->type("id=textareaPrompt", $savedata);
                        &click($locator_prompt_option0);
                        sleep 2;
                        # &click("id=storeBulk10");
                        last;
                    }
                }
            }
            if ( $sel->get_eval("window.Game.elderWrath") ) {
                &explode_wrinklers();
            }
        }
    } catch {
        print "ERROR: $_";
    };

    if ( $sel->is_element_present($locator_golden_cookie) && &click($locator_golden_cookie, "goldenCookie") ) {
        while ($sel->get_eval("window.Game.hasBuff('Cookie storm')")) {
            &click($locator_golden_cookie, "cookie storming");
        }
    }

    &click($locator_season_popup, "seasonPopup");

    &buy_upgrade();

    my $tm = time();
    if ( $tm - $tm0 >= 300 ) {
        &to_menu_and_click($locator_export, "export($tm)");
        $tm0 = $tm;
    }
}

sub to_menu_and_click {
    my $locator = shift;
    my $target_name = shift;
    my $locator_menu_button = '//div[@id="prefsButton"]';

    while (!&is_enable($locator)) {
        &click($locator_menu_button, "menu");
    }
    &click($locator, $target_name);
}

sub buy_upgrade {
    my $locator = '//div[@id="upgrades"]/div[@class="crate upgrade enabled"][1]';
    if ( &is_enable($locator) ) {
        &click($locator, "upgrade");
    }
}

sub is_enable {
    my $locator = shift;
    return $sel->is_element_present($locator);
}

sub explode_wrinklers {
    $sel->get_eval("window.Game.SaveWrinklers().number < window.Game.getWrinklersMax() || window.Game.CollectWrinklers()");
    print "explode wrinklers\n";
}

sub click {
    my $locator = shift;
    my $target_name = shift;
    my $rtn = 0;

    try {
        if ( $sel->is_visible($locator) ) {
            $sel->click($locator);
            print "click $target_name\n" if ( $target_name );
        }
        $rtn = 1;
    } catch {
        print "ERROR: $_";
    };
    return $rtn;
}

sub double_click {
    my $locator = shift;

    try {
        $sel->double_click($locator);
    } catch {
        print "ERROR: $_";
    };
}

sub get_text {
    my $locator = shift;
    my $text;

    while ( !defined($text) ) {
        try {
            $text = $sel->get_text($locator);
        } catch {
            print "ERROR: $_\n";
        };
    }

    return $text;
}
