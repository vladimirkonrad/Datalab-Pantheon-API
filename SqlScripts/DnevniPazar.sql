
/*
Primer procedure za ispis trenutnog pazara po maloprodajama (magacinima). U uslov where podasit broj dokumenta za prikaz. Update #temp tabele prilagodjava ispis bez đšžćč
*/

CREATE procedure [dbo].[iw_DnevniPazar] @OnlySum bit
as
declare
  @danas			smalldatetime;
  
begin
     -- exec iw_DnevniPazar 1

	 set @danas=  CONVERT (date, GETDATE()) 
     
      SELECT G.acKey,
			 substring(G.acKey,3,3) as MP,
			 G.acIssuer as Naziv,
             P.anNo,
             IsNull(DK.anSubNo,0) as Subno,
             IsNull(DK.anPVValue, P.anPVValue) as anPVValue,
             P.anPVExcise + case T.acVatCalcReceiver when 'T' then 0 else IsNull(DK.anVATValue, P.anPVVAT) end as Vat,
             IsNull(DK.anDiscount, P.anPVDiscount) as anPVDiscount,
             case T.acVatCalcReceiver when 'T' then IsNull(DK.anPVValue, P.anPVValue) - IsNull(DK.anDiscount , P.anPVDiscount) else IsNull(DK.anForPay, P.anPVForPay) end as Iznos,
             IsNull(DK.anPVValue, P.anPVValue) - IsNull(DK.anDiscount, P.anPVDiscount) as Nesto,
             P.anPrice,
             P.anPVExcise
			into #temp
			FROM  the_Move G JOIN the_MoveItem P ON G.acKey = P.acKey
                      JOIN tPA_SetDocType D  ON D.acDocType = G.acDocType
                      JOIN tHE_SetItem M     ON P.acIdent = M.acIdent
                      JOIN tHE_SetTax T      ON T.acVATCode = P.acVATCode
                 LEFT JOIN vHE_MoveItemDistKeyItem DK ON DK.acKey = P.acKey AND DK.anNo = P.anNo 
			WHERE   (G.acDocType IN ( '32A0', '32B0', '32C0', '32D0', '32E0', '32F0', '32G0', '32H0', '32I0', '32J0', '32K0', '32L0', '32M0', '32N0', '32O0', '32P0', '32Q0', '32R0', '32S0', '32T0', '32U0', '32V0', '32X0', '32Y0', '32Z0')) 
			AND (M.acSetOfItem IN ('100', '101', '200', '201', '202', '210', '211', '300', '400', '500', '600', '700', '701', '705')) AND (G.adDateInv >= @danas) AND (G.adDateInv <= @danas)
    

			 UPDATE #temp  
					SET     Naziv =  CASE  
											WHEN MP = '32Q' THEN 'MP Pancevo' 
											WHEN MP = '32H' THEN 'MP Cacak' 
											
											ELSE Naziv
										END 
					WHERE   MP IN ('32Q', '32H')

			if @OnlySum = 0
				SELECT MP,  Naziv,  count(acKey) as BrojRacuna, format(sum(Iznos),'N','en-us' )  as Pazar, sum(Iznos) as PazarNoFormat
				FROM #temp
				GROUP BY MP, Naziv
			else 
				SELECT format(sum(Iznos),'N','en-us' )  as Pazar, sum(Iznos) as PazarNoFormat
				FROM #temp
 
end;
