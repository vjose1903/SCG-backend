require 'test_helper'

class PermisosVehicularesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @permiso_vehicular = permisos_vehiculares(:one)
  end

  test "should get index" do
    get permisos_vehiculares_url, as: :json
    assert_response :success
  end

  test "should create permiso_vehicular" do
    assert_difference('PermisoVehicular.count') do
      post permisos_vehiculares_url, params: { permiso_vehicular: { activo: @permiso_vehicular.activo, descripcion: @permiso_vehicular.descripcion, estado: @permiso_vehicular.estado, persona_id: @permiso_vehicular.persona_id, tipo: @permiso_vehicular.tipo, valor: @permiso_vehicular.valor, vehiculo_id: @permiso_vehicular.vehiculo_id } }, as: :json
    end

    assert_response 201
  end

  test "should show permiso_vehicular" do
    get permiso_vehicular_url(@permiso_vehicular), as: :json
    assert_response :success
  end

  test "should update permiso_vehicular" do
    patch permiso_vehicular_url(@permiso_vehicular), params: { permiso_vehicular: { activo: @permiso_vehicular.activo, descripcion: @permiso_vehicular.descripcion, estado: @permiso_vehicular.estado, persona_id: @permiso_vehicular.persona_id, tipo: @permiso_vehicular.tipo, valor: @permiso_vehicular.valor, vehiculo_id: @permiso_vehicular.vehiculo_id } }, as: :json
    assert_response 200
  end

  test "should destroy permiso_vehicular" do
    assert_difference('PermisoVehicular.count', -1) do
      delete permiso_vehicular_url(@permiso_vehicular), as: :json
    end

    assert_response 204
  end
end
