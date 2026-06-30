package com.runtoolkit.rtwrapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.fabricmc.api.ModInitializer;

public final class RTWrapper implements ModInitializer {
    public static final String MOD_ID = "rtwrapper";
    public static final Logger LOGGER = LoggerFactory.getLogger(MOD_ID);

    @Override
    public void onInitialize() {
        LOGGER.info("RTWrapper initialized; embedded datapack namespace '{}' is available.", MOD_ID);
    }
}
