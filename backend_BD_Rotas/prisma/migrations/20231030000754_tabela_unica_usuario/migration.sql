/*
  Warnings:

  - You are about to drop the `Admin` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `NivelAcesso` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Suporte` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `idNivelAcesso` on the `Usuario` table. All the data in the column will be lost.
  - Added the required column `nivelAcesso` to the `Usuario` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "Admin_emailAdmin_key";

-- DropIndex
DROP INDEX "Admin_id_key";

-- DropIndex
DROP INDEX "Suporte_emailSuporte_key";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Admin";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "NivelAcesso";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Suporte";
PRAGMA foreign_keys=on;

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Usuario" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nomeUsuario" TEXT NOT NULL,
    "emailUsuario" TEXT NOT NULL,
    "telefoneUsuario" TEXT NOT NULL,
    "senhaUsuario" TEXT NOT NULL DEFAULT '',
    "nivelAcesso" TEXT NOT NULL
);
INSERT INTO "new_Usuario" ("emailUsuario", "id", "nomeUsuario", "senhaUsuario", "telefoneUsuario") SELECT "emailUsuario", "id", "nomeUsuario", "senhaUsuario", "telefoneUsuario" FROM "Usuario";
DROP TABLE "Usuario";
ALTER TABLE "new_Usuario" RENAME TO "Usuario";
CREATE UNIQUE INDEX "Usuario_emailUsuario_key" ON "Usuario"("emailUsuario");
CREATE TABLE "new_Chamado" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nomeChamado" TEXT NOT NULL,
    "descChamado" TEXT NOT NULL,
    "dataAberturaChamado" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idUsuario" INTEGER NOT NULL,
    "idSuporte" INTEGER,
    "idLab" INTEGER NOT NULL,
    "idComputador" INTEGER NOT NULL,
    "idCategoria" INTEGER NOT NULL,
    "idAndamento" INTEGER NOT NULL DEFAULT 1,
    "tratInicio" DATETIME,
    "tratFim" DATETIME,
    CONSTRAINT "Chamado_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idSuporte_fkey" FOREIGN KEY ("idSuporte") REFERENCES "Usuario" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idLab_fkey" FOREIGN KEY ("idLab") REFERENCES "Lab" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idComputador_fkey" FOREIGN KEY ("idComputador") REFERENCES "Computador" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idCategoria_fkey" FOREIGN KEY ("idCategoria") REFERENCES "Categoria" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idAndamento_fkey" FOREIGN KEY ("idAndamento") REFERENCES "Andamento" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Chamado" ("dataAberturaChamado", "descChamado", "id", "idAndamento", "idCategoria", "idComputador", "idLab", "idSuporte", "idUsuario", "nomeChamado", "tratFim", "tratInicio") SELECT "dataAberturaChamado", "descChamado", "id", "idAndamento", "idCategoria", "idComputador", "idLab", "idSuporte", "idUsuario", "nomeChamado", "tratFim", "tratInicio" FROM "Chamado";
DROP TABLE "Chamado";
ALTER TABLE "new_Chamado" RENAME TO "Chamado";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
