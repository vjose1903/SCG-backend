require 'test_helper'

class NotificacionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notificacion = notificacions(:one)
  end

  test "should get index" do
    get notificacions_url, as: :json
    assert_response :success
  end

  test "should create notificacion" do
    assert_difference('Notificacion.count') do
      post notificacions_url, params: { notificacion: { activo: @notificacion.activo, contenido: @notificacion.contenido, estado: @notificacion.estado, fecha_hora: @notificacion.fecha_hora, notificacion_origen_id: @notificacion.notificacion_origen_id, notificacion_origen_type: @notificacion.notificacion_origen_type, persona_id: @notificacion.persona_id, tipo: @notificacion.tipo } }, as: :json
    end

    assert_response 201
  end

  test "should show notificacion" do
    get notificacion_url(@notificacion), as: :json
    assert_response :success
  end

  test "should update notificacion" do
    patch notificacion_url(@notificacion), params: { notificacion: { activo: @notificacion.activo, contenido: @notificacion.contenido, estado: @notificacion.estado, fecha_hora: @notificacion.fecha_hora, notificacion_origen_id: @notificacion.notificacion_origen_id, notificacion_origen_type: @notificacion.notificacion_origen_type, persona_id: @notificacion.persona_id, tipo: @notificacion.tipo } }, as: :json
    assert_response 200
  end

  test "should destroy notificacion" do
    assert_difference('Notificacion.count', -1) do
      delete notificacion_url(@notificacion), as: :json
    end

    assert_response 204
  end
end
