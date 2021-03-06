/***************************************************************************
                 factteso_masterproveedores.qs  -  description
                             -------------------
    begin                : mie jul 29 2009
    copyright            : (C) 2009 by Silix
    email                : contacto@silix.com.ar
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration ctasCtes */
/////////////////////////////////////////////////////////////////
//// CTASCTES ///////////////////////////////////////////////////
class ctasCtes extends oficial {
	var comboBox1:Object;
	var ckbSoloCtaActiva:Object;

	function ctasCtes( context ) { oficial( context ); }
	function init() {
		this.ctx.ctasCtes_init();
	}
	function actualizarFiltroCombo() {
		return this.ctx.ctasCtes_actualizarFiltroCombo();
	}
}
//// CTASCTES ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// SILIXORDENCAMPOS ///////////////////////////////////////////
class silixOrdenCampos extends ctasCtes {
    function silixOrdenCampos( context ) { ctasCtes ( context ); }
	function init() {
		this.ctx.silixOrdenCampos_init();
	}
}
//// SILIXORDENCAMPOS ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends silixOrdenCampos {
    function head( context ) { silixOrdenCampos ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ctasCtes */
//////////////////////////////////////////////////////////////////
//// CTASCTES ////////////////////////////////////////////////////

function ctasCtes_init()
{
	try {	// funci�n de FLFormDB agregada por Silix
		this.setCaptionWidget("Cuentas corrientes de Proveedores");
	} catch (e) {}

	this.iface.comboBox1 = this.child("comboBox1");
	this.iface.ckbSoloCtaActiva = this.child("ckbSoloCtaActiva");

	this.child("tableDBRecords").setEditOnly(true);

	connect(this.iface.comboBox1, "activated(int)", this, "iface.actualizarFiltroCombo");
	connect(this.iface.ckbSoloCtaActiva, "clicked()",  this, "iface.actualizarFiltroCombo()");

	this.iface.actualizarFiltroCombo();
}

function ctasCtes_actualizarFiltroCombo()
{
	var util:FLUtil = new FLUtil();
	var cuentas = this.iface.comboBox1.currentItem;
	var filtro:String = "";

	switch (cuentas) {
	case 0: {
		break;
		}
	case 1: {
		filtro = "riesgoalcanzado <> 0";
		break;
		}
	case 2: {
		var hoy = new Date();
		var fechaV:String = hoy;
		filtro = "codproveedor IN ( SELECT DISTINCT codproveedor FROM recibosprov WHERE estado <> 'Pagado' AND fechav < '" + fechaV + "' )";
		break;
		}
	}

	if (this.iface.ckbSoloCtaActiva.checked) {
		if (filtro)
			filtro += " AND ";
		filtro += "cuentactiva = true";
	}

	this.child("tableDBRecords").setFilter(filtro);
	this.child("tableDBRecords").refresh();
	this.child("tableDBRecords").setFocus();
}

//// CTASCTES ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition silixOrdenCampos */
/////////////////////////////////////////////////////////////////
//// SILIXORDENCAMPOS ///////////////////////////////////////////

function silixOrdenCampos_init()
{
	this.iface.__init();

	var orden:Array = [ "nombre", "codproveedor", "cifnif", "riesgoalcanzado", "cuentactiva" ];
	this.child("tableDBRecords").setOrderCols(orden);
	this.child("tableDBRecords").setFocus();
}

//// SILIXORDENCAMPOS ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
