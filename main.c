#include "MKL46Z4.h"
#include "FreeRTOS.h"
#include "task.h"

void led_green_init()
{
	SIM_COPC = 0;
	SIM_SCGC5 |= SIM_SCGC5_PORTD_MASK;
	PORTD_PCR5 = PORT_PCR_MUX(1);
	GPIOD_PDDR |= (1 << 5);
	GPIOD_PSOR = (1 << 5);
}

void led_green_toggle()
{
	GPIOD_PTOR = (1 << 5);
}

void led_red_init()
{
	SIM_COPC = 0;
	SIM_SCGC5 |= SIM_SCGC5_PORTE_MASK;
	PORTE_PCR29 = PORT_PCR_MUX(1);
	GPIOE_PDDR |= (1 << 29);
	GPIOE_PSOR = (1 << 29);
}

void led_red_toggle(void)
{
	GPIOE_PTOR = (1 << 29);
}

void taskLedGreen(void *pvParameters)
{
    for (;;) {
        led_green_toggle();
        vTaskDelay(200/portTICK_RATE_MS);
    }
}

void taskLedRed(void *pvParameters)
{
    for (;;) {
        led_red_toggle();
        vTaskDelay(500/portTICK_RATE_MS);
    }
}

int main(void)
{
	led_green_init();
	led_red_init();

	/* create green led task */
	xTaskCreate(taskLedGreen, (signed char *)"TaskLedGreen", 
		configMINIMAL_STACK_SIZE, (void *)NULL, 1, NULL);

	/* create red led task */
	xTaskCreate(taskLedRed, (signed char *)"TaskLedRed", 
		configMINIMAL_STACK_SIZE, (void *)NULL, 1, NULL);
	
	/* start the scheduler */
	vTaskStartScheduler();

	/* should never reach here! */
	for (;;);

	return 0;
}

