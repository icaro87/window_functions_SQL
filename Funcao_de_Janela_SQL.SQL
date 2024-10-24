*********************** FUNÇÃO DE JANELA SQL ***********************

--- EXIBE O TOTAL DE VENDAS NUMA NOVA COLUNA
SELECT 
  *,
  SUM(QTD_VENDIDA) OVER() AS TOTAL_VENDIDO
FROM VENDAS

===============================================================================================================

--- OBTER O PERCENTUAL VENDIDO POR REGIÃO
SELECT
  *,
  ROUND(QTD_VENDIDA / SUM(QTD_VENDIDA) OVER(PARTITION BY REGIAO), 2) AS PERC_VENDA_REGIAO
FROM VENDAS
ORDER BY ID_LOJA

===============================================================================================================

--- RANQUEAMENTO DE LOJAS PELO TOTAL DE VENDAS
SELECT 
  *,
  ROW_NUMBER() OVER(ORDER BY QTD_VENDIDA DESC) AS RANK1,
  RANK() OVER(ORDER BY QTD_VENDIDA DESC) AS RANK2,
  DENSE_RANK() OVER(ORDER BY QTD_VENDIDA DESC) AS RANK3
FROM VENDAS
WHERE REGIAO = 'SUDESTE'

===============================================================================================================

--- OBTENDO AS MÉDIAS MÓVEIS DOS ÚLTIMOS 3 MESES
SELECT 
  *, 
  ROUND( AVG(FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) AS MEDIA_MOVEL
FROM DF_DATAS

===============================================================================================================

--- OBTENDO AS SOMAS MÓVEIS DOS ÚTIMOS 3 MESES 
SELECT
  *, 
  SUM(FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS SOMA_MOVEL
FROM DF_DATAS

===============================================================================================================

--- MOM
SELECT 
  *, 
  LAG(FATURAMENTOMM, 1, 0) OVER(ORDER BY DATAFECHAMENTO) AS FATMESANTERIOR,
  ROUND((FATURAMENTOMM/LAG(FATURAMENTOMM, 1, FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO)-1), 3) AS 'CRESC_M-1'
FROM DF_DATAS

===============================================================================================================

--- YOY
SELECT 
  *, 
  LAG(FATURAMENTOMM, 12, 0) OVER(ORDER BY DATAFECHAMENTO) AS FATMESANTERIOR,
  ROUND((FATURAMENTOMM/LAG(FATURAMENTOMM, 12, FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO)-1), 3) AS 'CRESC_M-12'
FROM DF_DATAS

===============================================================================================================

--- TOTAL ACUMULADO
SELECT 
  *, 
  SUM(FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ACUMULADO,
  ROUND(  SUM(FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/SUM(FATURAMENTOMM) OVER(), 3) AS PERC_ACUM
FROM DF_DATAS

===============================================================================================================

--- LOJA COM MAIOR VOLUME DE VENDAS POR REGIÃO
SELECT 
*
FROM
(
    SELECT 
      *,
      FIRST_VALUE(NOME_LOJA) OVER(PARTITION BY REGIAO ORDER BY QTD_VENDIDA DESC) AS TOP_NAME
    FROM VENDAS
    ORDER BY 1
)
WHERE NOME_LOJA = TOP_NAME

===============================================================================================================

--- SEGUNDA LOJA COM MAIOR VOLUME DE VENDAS POR REGIÃO
SELECT
*
FROM
(
  SELECT 
    *,
    NTH_VALUE(NOME_LOJA, 2) OVER(PARTITION BY REGIAO ORDER BY QTD_VENDIDA DESC) AS TOP2_NAME
  FROM VENDAS
  ORDER BY 1
)
WHERE NOME_LOJA = TOP2_NAME

===============================================================================================================

--- MÉDIAS MÓVEIS CONSIDERANDO M-1 / M / M+1
SELECT
  *,
  ROUND( AVG(FATURAMENTOMM) OVER(ORDER BY DATAFECHAMENTO ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 3) AS MEDIA_MOVEL
FROM DF_DATAS
