/*
  Warnings:

  - The values [sensor,actuator] on the enum `DeviceType` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `sensorId` on the `alerts` table. All the data in the column will be lost.
  - You are about to drop the column `status` on the `notifications` table. All the data in the column will be lost.
  - You are about to drop the column `action` on the `pump_control` table. All the data in the column will be lost.
  - You are about to drop the column `timestamp` on the `pump_control` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `pump_control` table. All the data in the column will be lost.
  - You are about to drop the column `soilMoisture` on the `sensor_data` table. All the data in the column will be lost.
  - You are about to drop the column `temperature` on the `sensor_data` table. All the data in the column will be lost.
  - Added the required column `dataType` to the `sensor_data` table without a default value. This is not possible if the table is not empty.
  - Added the required column `value` to the `sensor_data` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "DataType" AS ENUM ('temperature', 'humidity', 'soil', 'light');

-- AlterEnum
BEGIN;
CREATE TYPE "DeviceType_new" AS ENUM ('TEMPERATURE_SENSOR', 'SOIL_SENSOR', 'LIGHT_SENSOR', 'PUMP', 'LED', 'LCD');
ALTER TABLE "devices" ALTER COLUMN "deviceType" TYPE "DeviceType_new" USING ("deviceType"::text::"DeviceType_new");
ALTER TYPE "DeviceType" RENAME TO "DeviceType_old";
ALTER TYPE "DeviceType_new" RENAME TO "DeviceType";
DROP TYPE "DeviceType_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "alerts" DROP CONSTRAINT "alerts_sensorId_fkey";

-- DropForeignKey
ALTER TABLE "pump_control" DROP CONSTRAINT "pump_control_userId_fkey";

-- DropIndex
DROP INDEX "alerts_sensorId_triggeredAt_idx";

-- DropIndex
DROP INDEX "notifications_userId_status_idx";

-- DropIndex
DROP INDEX "pump_control_deviceId_timestamp_idx";

-- DropIndex
DROP INDEX "sensor_data_deviceId_recordedAt_idx";

-- AlterTable
ALTER TABLE "alerts" DROP COLUMN "sensorId",
ADD COLUMN     "sensorDataId" INTEGER;

-- AlterTable
ALTER TABLE "notifications" DROP COLUMN "status",
ADD COLUMN     "isRead" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "pump_control" DROP COLUMN "action",
DROP COLUMN "timestamp",
DROP COLUMN "userId",
ADD COLUMN     "isOn" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "sensor_data" DROP COLUMN "soilMoisture",
DROP COLUMN "temperature",
ADD COLUMN     "dataType" "DataType" NOT NULL,
ADD COLUMN     "value" DOUBLE PRECISION NOT NULL;

-- DropEnum
DROP TYPE "NotificationStatus";

-- DropEnum
DROP TYPE "PumpAction";

-- CreateTable
CREATE TABLE "display_log" (
    "id" SERIAL NOT NULL,
    "deviceId" INTEGER NOT NULL,
    "content" VARCHAR(32) NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "display_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rgb_control" (
    "id" SERIAL NOT NULL,
    "deviceId" INTEGER NOT NULL,
    "isOn" BOOLEAN NOT NULL DEFAULT false,
    "value" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rgb_control_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "display_log_deviceId_idx" ON "display_log"("deviceId");

-- CreateIndex
CREATE INDEX "rgb_control_deviceId_updatedAt_idx" ON "rgb_control"("deviceId", "updatedAt");

-- CreateIndex
CREATE INDEX "rgb_control_isOn_idx" ON "rgb_control"("isOn");

-- CreateIndex
CREATE INDEX "alerts_sensorDataId_triggeredAt_idx" ON "alerts"("sensorDataId", "triggeredAt");

-- CreateIndex
CREATE INDEX "devices_deviceType_idx" ON "devices"("deviceType");

-- CreateIndex
CREATE INDEX "devices_location_idx" ON "devices"("location");

-- CreateIndex
CREATE INDEX "notifications_userId_isRead_idx" ON "notifications"("userId", "isRead");

-- CreateIndex
CREATE INDEX "pump_control_deviceId_updatedAt_idx" ON "pump_control"("deviceId", "updatedAt");

-- CreateIndex
CREATE INDEX "pump_control_isOn_idx" ON "pump_control"("isOn");

-- CreateIndex
CREATE INDEX "sensor_data_dataType_idx" ON "sensor_data"("dataType");

-- CreateIndex
CREATE INDEX "sensor_data_recordedAt_idx" ON "sensor_data"("recordedAt");

-- CreateIndex
CREATE INDEX "sensor_data_deviceId_dataType_recordedAt_idx" ON "sensor_data"("deviceId", "dataType", "recordedAt");

-- AddForeignKey
ALTER TABLE "display_log" ADD CONSTRAINT "display_log_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rgb_control" ADD CONSTRAINT "rgb_control_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alerts" ADD CONSTRAINT "alerts_sensorDataId_fkey" FOREIGN KEY ("sensorDataId") REFERENCES "sensor_data"("id") ON DELETE SET NULL ON UPDATE CASCADE;
