cmake_minimum_required(VERSION 3.27.1)

if(${CONFIG_FREERTOS})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1/port.c
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_4.c
    )

    list(APPEND DRIVER_INC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/include
    )
endif()

if(${CONFIG_FREERTOS_TASKS})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/tasks.c
    )
endif()

if(${CONFIG_FREERTOS_CROUTINE})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/croutine.c
    )
endif()

if(${CONFIG_FREERTOS_EVENT_GROUP})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/event_groups.c
    )
endif()

if(${CONFIG_FREERTOS_LIST})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/list.c
    )
endif()

if(${CONFIG_FREERTOS_QUEUE})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/queue.c
    )
endif()

if(${CONFIG_FREERTOS_STREAM_BUFFER})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/stream_buffer.c
    )
endif()


if(${CONFIG_FREERTOS_TIMERS})
    list(APPEND DRIVER_SRC
        ${SDK_BASE}/modules/FreeRTOS/FreeRTOS/Source/timers.c
    )
endif()