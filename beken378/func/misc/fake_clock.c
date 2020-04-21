#include "sys_rtos.h"
#include "fake_clock_pub.h"
#include "pwm_pub.h"
#include "icu_pub.h"
#include "drv_model_pub.h"
#include "uart_pub.h"
#include "rtos_pub.h"
#if (CFG_SUPPORT_ALIOS)
#include "k_api.h"
#endif
#include "power_save_pub.h"

static volatile UINT32 current_clock = 0;
static volatile UINT32 current_seconds = 0;
static UINT32 second_countdown = FCLK_SECOND;

void fclk_hdl(UINT8 param)
{
    GLOBAL_INT_DECLARATION();

    current_clock ++;

#if (CFG_OS_FREERTOS)
    /* Increment the tick counter. */
    GLOBAL_INT_DISABLE();
    if( xTaskIncrementTick() != pdFALSE )
    {
        /* Select a new task to run. */
        vTaskSwitchContext();
    }
    GLOBAL_INT_RESTORE();
#endif
    if (--second_countdown == 0)
    {
        current_seconds ++;
        second_countdown = FCLK_SECOND;
    }

#if (CFG_SUPPORT_ALIOS)
    krhino_tick_proc();
#endif
}

static UINT32 fclk_freertos_update_tick(UINT32 tick)
{
    current_clock += tick;

    while(tick >= FCLK_SECOND)
    {
        current_seconds ++;
        tick -= FCLK_SECOND;
    }

    if(second_countdown <= tick)
    {
        current_seconds ++;
        second_countdown = FCLK_SECOND - (tick - second_countdown);
    }
    else
    {
        second_countdown -= tick;
    }

    return 0;
}

UINT32 fclk_update_tick(UINT32 tick)
{
#if (CFG_SUPPORT_RTT)
    rtt_update_tick(tick);
#elif (CFG_SUPPORT_ALIOS)
    krhino_update_sys_tick((UINT64)tick);
#else
    fclk_freertos_update_tick(tick);
    vTaskStepTick( tick );
#endif
    return 0;
}

UINT32 fclk_freertos_get_tick(void)
{
    return current_clock;
}

UINT64 fclk_get_tick(void)
{
    UINT64 fclk;
#if (CFG_SUPPORT_RTT)
    fclk = (UINT64)rt_tick_get();
#elif (CFG_SUPPORT_ALIOS)
    fclk = krhino_sys_tick_get();
#else
    fclk = (UINT64)fclk_freertos_get_tick();
#endif
    return fclk;
}

UINT32 fclk_get_second(void)
{
#if (CFG_SUPPORT_RTT)
    return (rt_tick_get()/FCLK_SECOND);
#elif (CFG_SUPPORT_ALIOS)
    return (krhino_sys_tick_get()/FCLK_SECOND);
#else
    return current_seconds;
#endif
}

UINT32 fclk_from_sec_to_tick(UINT32 sec)
{
    return sec * FCLK_SECOND;
}

void fclk_reset_count(void)
{
    current_clock = 0;
    current_seconds = 0;
}

UINT32 fclk_cal_endvalue(UINT32 mode)
{
    UINT32 value = 1;

    if(PWM_CLK_32K == mode)
    {
        /*32k clock*/
        value = FCLK_DURATION_MS * 32;
    }
    else if(PWM_CLK_26M == mode)
    {
        /*26m clock*/
#if (CFG_SUPPORT_ALIOS)
	value = 26000000 / RHINO_CONFIG_TICKS_PER_SECOND;
#else
        value = FCLK_DURATION_MS * 26000;
#endif
    }

    return value;
}

void fclk_init(void)
{
    UINT32 ret;
    pwm_param_t param;

    /*init pwm*/
    param.channel         = FCLK_PWM_ID;
    param.cfg.bits.en     = PWM_ENABLE;
    param.cfg.bits.int_en = PWM_INT_EN;
    param.cfg.bits.mode   = PMODE_TIMER;

#if(CFG_RUNNING_PLATFORM == FPGA_PLATFORM)  // FPGA:PWM0-2-32kCLK, pwm3-5-24CLK
    param.cfg.bits.clk    = PWM_CLK_32K;
#else
    param.cfg.bits.clk    = PWM_CLK_26M;
#endif

    param.p_Int_Handler   = fclk_hdl;
    param.duty_cycle      = 0;
    param.end_value       = fclk_cal_endvalue((UINT32)param.cfg.bits.clk);

    ret = sddev_control(PWM_DEV_NAME, CMD_PWM_INIT_PARAM, &param);
    ASSERT(PWM_SUCCESS == ret);
}

// eof

