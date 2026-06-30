package com.runtoolkit.rtwrapper.gametest;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import net.fabricmc.fabric.api.gametest.v1.CustomTestMethodInvoker;
import net.fabricmc.fabric.api.gametest.v1.GameTest;
import net.minecraft.gametest.framework.GameTestHelper;
import net.minecraft.world.scores.ScoreHolder;

public final class RTWrapperGameTests implements CustomTestMethodInvoker {
    @GameTest
    public void modInitializes(GameTestHelper context) {
        context.succeed();
    }

    @GameTest
    public void datapackSmokeWithCmd(GameTestHelper context) {
        runSmokeFunction(context, "rtwrapper:tests/datapack_smoke", "#smoke");
        context.succeed();
    }

    @GameTest
    public void datapackSmokeWithTypeAlias(GameTestHelper context) {
        runSmokeFunction(context, "rtwrapper:tests/datapack_smoke_type", "#smoke_type");
        context.succeed();
    }

    private static void runSmokeFunction(GameTestHelper context, String function, String scoreHolderName) {
        var server = context.getLevel().getServer();
        server.getCommands().performPrefixedCommand(
                server.createCommandSourceStack(),
                "function " + function
        );

        var objective = context.getLevel().getScoreboard().getObjective("rtw.test");
        context.assertTrue(objective != null, "rtw.test objective should exist after datapack smoke function");

        var score = context.getLevel().getScoreboard().getPlayerScoreInfo(ScoreHolder.forNameOnly(scoreHolderName), objective);
        context.assertTrue(score != null && score.value() == 1, scoreHolderName + " rtw.test should be 1 after wrapper dispatch");
    }

    @Override
    public void invokeTestMethod(GameTestHelper context, Method method) throws ReflectiveOperationException {
        try {
            method.invoke(this, context);
        } catch (InvocationTargetException exception) {
            Throwable cause = exception.getCause();
            if (cause instanceof RuntimeException runtimeException) {
                throw runtimeException;
            }
            if (cause instanceof Error error) {
                throw error;
            }
            throw exception;
        }
    }
}
