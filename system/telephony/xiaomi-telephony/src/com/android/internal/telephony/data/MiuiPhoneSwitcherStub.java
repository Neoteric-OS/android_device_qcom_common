package com.android.internal.telephony.data;

public class MiuiPhoneSwitcherStub {

    public interface IMiuiPhoneSwitcher {
        boolean updatePreferredDataPhoneId();
    }

    private static final IMiuiPhoneSwitcher INSTANCE = new IMiuiPhoneSwitcher() {
        @Override
        public boolean updatePreferredDataPhoneId() {
            return false;
        }
    };

    public static IMiuiPhoneSwitcher get() {
        return INSTANCE;
    }
}
